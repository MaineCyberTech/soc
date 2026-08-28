#!/usr/bin/env bash
# P62 evidence-authenticity CI: fails closed if any acceptance gate is not met,
# INCLUDING that every execution_id in phase62-states.json is a REAL Shuffle execution.
set -euo pipefail
ROOT="/opt/mct-security-stack"
PACK="/home/user/mct-p62"
GEN="$ROOT/ops/reports/generated/phase62"
EVID="$ROOT/ops/evidence"

source "$ROOT/.env" 2>/dev/null
export SHUFFLE_API_KEY
export API="http://127.0.0.1:5001/api/v1"

echo "[1/6] time-anchor"; python3 "$PACK/ops/scripts/p62-time-anchor.py" >/dev/null
echo "[2/6] inventory (400 unique)"; python3 "$PACK/ops/scripts/p62-inventory.py" "$GEN" >/dev/null
echo "[3/6] correlation-validate (8 keys)"; python3 "$PACK/ops/scripts/p62-correlation-validate.py" "$EVID/phase62-correlation.json" >/dev/null
echo "[4/6] state-validate (13 states w/ execution_id)"; python3 "$PACK/ops/scripts/p62-state-validate.py" "$EVID/phase62-states.json" >/dev/null

echo "[5/6] literal-detector (old IRIS key absent)"
if grep -rl "31475ce60587be55229c3bf97ac3c317a417a38a53990f4b7e7457616b7852d5" "$GEN" "$EVID" 2>/dev/null; then
  echo "LITERAL IRIS KEY FOUND -- FAIL"; exit 1
fi
echo "  literal-detector: 0"

echo "[6/6] AUTHENTICITY: every state execution_id exists in live Shuffle"
# Collect real execution ids from both workflows
python3 - "$EVID/phase62-states.json" <<PY
import json,sys,subprocess,urllib.request,os
d=json.load(open(sys.argv[1]))
ids=set()
for wf in ["c6b3fcd8-13e5-44a8-a818-024e4ae4422b","e133a645-95b9-4e01-9454-e270d2a0b599"]:
    url=f"{os.environ['API']}/workflows/{wf}/executions?limit=200"
    req=urllib.request.Request(url, headers={"Authorization":"Bearer "+os.environ['SHUFFLE_API_KEY']})
    try:
        data=json.load(urllib.request.urlopen(req, timeout=15))
    except Exception as e:
        print("FETCH FAIL", e); sys.exit(1)
    for e in data:
        ids.add(e.get('execution_id') or e.get('id'))
missing=[t['execution_id'] for t in d['tests'] if t.get('execution_id') not in ids]
if missing:
    print("EXECUTION_IDS NOT FOUND IN SHUFFLE:", missing); sys.exit(1)
print(f"  all {len(d['tests'])} state execution_ids verified present in Shuffle ({len(ids)} executions scanned)")
PY

echo "P62 EVIDENCE-AUTHENTICITY CI: PASS (errors=0 warnings=0)"
