#!/usr/bin/env bash
# p63-agents-ci.sh - P63 phase CI gate.
# Validates: report inventory, correlation JSON, state JSON, production JSON,
# execution authenticity (live Shuffle), and secret-pattern scan.
# Exits non-zero on any failure.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
GEN="$ROOT/ops/reports/generated/phase63"
EVID="$ROOT/ops/evidence"
SCRIPTS="$ROOT/ops/scripts"

# load Shuffle API key if available (gitignored .env)
if [ -f "$ROOT/.env" ]; then
  set -a; . "$ROOT/.env"; set +a
fi

WF="c6b3fcd8-13e5-44a8-a818-024e4ae4422b"
PASS=0; FAIL=0

run() { echo "=== $1 ==="; if "$@"; then echo "OK: $1"; PASS=$((PASS+1)); else echo "FAIL: $1"; FAIL=$((FAIL+1)); fi; }

# 1. inventory (expects 410 uniquely numbered 000-409)
run python3 "$SCRIPTS/p63-inventory.py" "$GEN"

# 2. correlation schema (8 keys)
run python3 "$SCRIPTS/p63-correlation-validate.py" "$EVID/phase63-correlation.json"

# 3. state coverage (13 states, each with live_current_revision/execution_id/observed_state)
run python3 "$SCRIPTS/p63-state-validate.py" "$EVID/phase63-states.json"

# 4. production JSON (7 keys)
run python3 "$SCRIPTS/p63-production-validate.py" "$EVID/phase63-production.json"

# 5. execution authenticity: each execution_id must appear in live Shuffle executions list
# (Shuffle has no single-execution GET; we enumerate the per-workflow executions lists).
echo "=== execution authenticity (live Shuffle) ==="
if [ -n "${SHUFFLE_API_KEY:-}" ]; then
  ids=$(python3 - "$EVID/phase63-correlation.json" "$EVID/phase63-states.json" <<'PY'
import json,sys
s=set()
s.add(json.load(open(sys.argv[1])).get("shuffle_execution_id"))
for t in json.load(open(sys.argv[2])).get("tests",[]):
    if t.get("execution_id"): s.add(t["execution_id"])
print("\n".join(x for x in s if x))
PY
)
  # enumerate executions for both relevant workflows
  python3 - "$WF" "e133a645-95b9-4e01-9454-e270d2a0b599" > /tmp/p63-exec-ids.txt <<'PY'
import json,sys,urllib.request,urllib.error
key=open("/opt/mct-security-stack/.env").read()
import re
m=re.search(r"SHUFFLE_API_KEY=(\S+)",key)
token=m.group(1)
found=set()
for wf in sys.argv[1:]:
    url=f"http://127.0.0.1:5001/api/v1/workflows/{wf}/executions?limit=1000"
    req=urllib.request.Request(url,headers={"Authorization":f"Bearer {token}"})
    try:
        data=json.load(urllib.request.urlopen(req,timeout=20))
    except Exception as e:
        print(f"# list error {wf}: {e}",file=sys.stderr); continue
    for e in (data if isinstance(data,list) else []):
        found.add(e.get("execution_id") or e.get("id"))
print("\n".join(x for x in found if x))
PY
  bad=0
  while read -r eid; do
    [ -z "$eid" ] && continue
    if grep -qx "$eid" /tmp/p63-exec-ids.txt; then echo "OK authenticity: $eid"; else echo "FAIL authenticity: $eid NOT in live Shuffle"; bad=1; fi
  done <<< "$ids"
  if [ "$bad" -eq 0 ]; then PASS=$((PASS+1)); else FAIL=$((FAIL+1)); fi
else
  echo "SKIP authenticity: SHUFFLE_API_KEY not set"
fi

# 6. secret-pattern scan over the repo (excludes reports/evidence per scan script)
echo "=== secret-pattern scan ==="
if bash "$SCRIPTS/secret-pattern-scan.sh" >/tmp/p63-secret-scan.txt 2>&1; then
  echo "scan ran"; cat /tmp/p63-secret-scan.txt | tail -5
else
  echo "FAIL secret scan"; FAIL=$((FAIL+1))
fi

echo
echo "=== P63 CI summary: PASS=$PASS FAIL=$FAIL ==="
exit $FAIL
