#!/usr/bin/env bash
# p64-agents-ci.sh - P64 phase CI gate.
# Validates: report inventory, config-source (8 keys), correlation JSON (8 keys),
# state JSON (13 states), execution authenticity (live Shuffle), and secret scan.
# Exits non-zero on any failure.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
GEN="$ROOT/ops/reports/generated/phase64"
EVID="$ROOT/ops/evidence"
SCRIPTS="$ROOT/ops/scripts"

if [ -f "$ROOT/.env" ]; then set -a; . "$ROOT/.env"; set +a; fi

WF="c6b3fcd8-13e5-44a8-a818-024e4ae4422b"
PASS=0; FAIL=0
run() { echo "=== $1 ==="; if "$@"; then echo "OK: $1"; PASS=$((PASS+1)); else echo "FAIL: $1"; FAIL=$((FAIL+1)); fi; }

run python3 "$SCRIPTS/p64-inventory.py" "$GEN"
run python3 "$SCRIPTS/p64-config-validate.py" "$EVID/phase64-config.json"
run python3 "$SCRIPTS/p64-correlation-validate.py" "$EVID/phase64-correlation.json"
run python3 "$SCRIPTS/p64-state-validate.py" "$EVID/phase64-states.json"

echo "=== execution authenticity (live Shuffle) ==="
if [ -n "${SHUFFLE_API_KEY:-}" ]; then
  ids=$(python3 - "$EVID/phase64-correlation.json" "$EVID/phase64-states.json" <<'PY'
import json,sys
s=set()
c=json.load(open(sys.argv[1]))
s.add(c.get("shuffle_execution_id"))
for t in json.load(open(sys.argv[2])).get("tests",[]):
    if t.get("execution_id"): s.add(t["execution_id"])
print("\n".join(x for x in s if x))
PY
)
  python3 - "$WF" "e133a645-95b9-4e01-9454-e270d2a0b599" > /tmp/p64-exec-ids.txt <<'PY'
import json,sys,urllib.request,re
key=open("/opt/mct-security-stack/.env").read()
tok=re.search(r"SHUFFLE_API_KEY=(\S+)",key).group(1)
found=set()
for wf in sys.argv[1:]:
    try:
        data=json.load(urllib.request.urlopen(urllib.request.Request(f"http://127.0.0.1:5001/api/v1/workflows/{wf}/executions?limit=1000",headers={"Authorization":f"Bearer {tok}"}),timeout=20))
        for e in (data if isinstance(data,list) else []): found.add(e.get("execution_id") or e.get("id"))
    except Exception as e:
        print(f"# list err {wf}: {e}",file=sys.stderr)
print("\n".join(x for x in found if x))
PY
  bad=0
  while read -r eid; do
    [ -z "$eid" ] && continue
    if grep -qx "$eid" /tmp/p64-exec-ids.txt; then echo "OK authenticity: $eid"; else echo "FAIL authenticity: $eid NOT in live Shuffle"; bad=1; fi
  done <<< "$ids"
  if [ "$bad" -eq 0 ]; then PASS=$((PASS+1)); else FAIL=$((FAIL+1)); fi
else
  echo "SKIP authenticity: SHUFFLE_API_KEY not set"
fi

echo "=== secret-pattern scan ==="
if bash "$SCRIPTS/secret-pattern-scan.sh" >/tmp/p64-secret-scan.txt 2>&1; then
  echo "scan ran"; grep -i "phase64\|ossec.conf" /tmp/p64-secret-scan.txt | head -5 || echo "(no phase64/ossec hits)"
else
  echo "FAIL secret scan"; FAIL=$((FAIL+1))
fi

echo; echo "=== P64 CI summary: PASS=$PASS FAIL=$FAIL ==="
exit $FAIL
