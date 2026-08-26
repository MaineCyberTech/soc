#!/usr/bin/env bash
# p39-iris-delivery-check.sh
# ALERT-39-01 monitor: classify recent executions of the Wazuh->IRIS workflows as
# DELIVERED / FAILED / ABORTED by parsing stored action results.
#   DELIVERED : terminal FINISHED and IRIS HTTP action parsed {"status":200,"body":{"status":"success"}}
#   FAILED    : terminal FINISHED whose result bears 'success": false'
#               (ConnectionError / HTTP error class)
#   ABORTED   : terminal status ABORTED (counted separately from FAILED per design)
# One row per execution_id -> dedupe by execution_id is inherent.
# Never prints tokens or alert bodies. Exit 0 in monitor mode; exit 2 on transport errors.
# Usage: p39-iris-delivery-check.sh [WORKFLOW_UUID[,UUID...]] [LIMIT]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
IFS=',' read -r -a WORKFLOWS <<< "${1:-eb937a37-5244-46dc-95ff-62ad4c681322,e951db98-9a57-4328-8344-09f8b5b9a69f}"
LIMIT=${2:-500}

set -a; source "$ROOT/.env" 2>/dev/null; set +a
if [ -z "${SHUFFLE_API_KEY:-}" ]; then
  echo "ERROR: SHUFFLE_API_KEY not set (expected via $ROOT/.env)"; exit 2
fi
if ! docker ps --format '{{.Names}}' | grep -q '^shuffle-backend$'; then
  echo "ERROR: shuffle-backend not running"; exit 2
fi

TMP=$(mktemp /tmp/opencode/p39-delivery.XXXXXX.py) || exit 2
trap 'rm -f "$TMP"' EXIT
cat > "$TMP" <<'PYEOF'
import json, sys
wf = sys.argv[1]
d = json.load(sys.stdin)
exs = d if isinstance(d, list) else d.get("results", d.get("executions", []))
D = F = A = O = 0; last_fail = ""
for e in exs:
    st = e.get("status"); ok = False; bad = False
    items = e.get("results") or []
    if isinstance(items, str):
        try: items = json.loads(items)
        except Exception: items = []
    for r in items:
        rr = r.get("result")
        try:
            rrj = json.loads(rr) if isinstance(rr, str) else rr
        except Exception:
            if isinstance(rr, str) and 'success": false' in rr: bad = True
            continue
        if isinstance(rrj, dict):
            body = rrj.get("body")
            if rrj.get("status") == 200 and isinstance(body, dict) and body.get("status") == "success":
                ok = True
            elif rrj.get("success") is False or "success" in str(rrj.get("exception", "")).lower():
                bad = True
    if st == "ABORTED":
        A += 1; last_fail = str(e.get("started_at", ""))
    elif st == "FINISHED" and ok:
        D += 1
    elif st == "FINISHED" and bad:
        F += 1; last_fail = str(e.get("started_at", ""))
    else:
        O += 1
print(f"{wf[:8]}  executions={len(exs)}  delivered={D}  failed={F}  aborted={A}  other={O}  last_failed_started_at={last_fail}")
print(f"TOTALS {D} {F} {A} {O}")
PYEOF

TD=0; TF=0; TA=0; TO=0
for WF in "${WORKFLOWS[@]}"; do
  JSON=$(docker exec shuffle-backend sh -lc \
    "wget -q -O- --timeout=20 --header='Authorization: Bearer ${SHUFFLE_API_KEY}' \"http://localhost:5001/api/v1/workflows/$WF/executions?limit=$LIMIT\"" 2>/dev/null)
  if [ -z "$JSON" ]; then echo "ERROR: no API response for $WF"; exit 2; fi
  OUT=$(printf '%s' "$JSON" | python3 "$TMP" "$WF")
  echo "$OUT" | head -1
  read -r _ D F A O <<< "$(echo "$OUT" | tail -1)"
  TD=$((TD+D)); TF=$((TF+F)); TA=$((TA+A)); TO=$((TO+O))
done
echo "== ALERT-39-01 SUMMARY: delivered=$TD failed=$TF aborted=$TA other=$TO =="
exit 0
