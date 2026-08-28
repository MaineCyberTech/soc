#!/usr/bin/env bash
# P61 preventive CI: fails closed if any acceptance gate is not met.
# Usage: ops/scripts/p61-agents-ci.sh
set -euo pipefail
ROOT="/opt/mct-security-stack"
PACK="/home/user/mct-p61"
GEN="$ROOT/ops/reports/generated/phase61"
EVID="$ROOT/ops/evidence"

echo "[1/5] time-anchor"
python3 "$PACK/ops/scripts/p61-time-anchor.py" >/dev/null

echo "[2/5] inventory (380 unique, none missing)"
python3 "$PACK/ops/scripts/p61-inventory.py" "$GEN"

echo "[3/5] correlation-validate (8 keys)"
python3 "$PACK/ops/scripts/p61-correlation-validate.py" "$EVID/phase61-correlation.json"

echo "[4/5] state-validate (13 current-revision states)"
python3 "$PACK/ops/scripts/p61-state-validate.py" "$EVID/phase61-states.json"

echo "[5/5] literal-detector (old IRIS key must be absent from reports)"
if grep -rl "31475ce60587be55229c3bf97ac3c317a417a38a53990f4b7e7457616b7852d5" "$GEN" "$EVID" 2>/dev/null; then
  echo "LITERAL IRIS KEY FOUND -- FAIL"; exit 1
fi
echo "literal-detector: 0"

echo "P61 PREVENTIVE CI: PASS (errors=0 warnings=0)"
