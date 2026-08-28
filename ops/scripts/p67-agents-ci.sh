#!/usr/bin/env bash
# p67-agents-ci.sh - Phase 67 CI gate.
# Validates: report inventory (520), time-anchor, e2e correlation (9 keys),
# endpoint (non-loopback + required fields), openwork (OW-66-01 not open; no CLOSED in open),
# retry design (7 keys), plus secret scan. Exits non-zero on any hard failure.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
GEN="$ROOT/ops/reports/generated/phase67"
EVID="$ROOT/ops/evidence"
SCRIPTS="$ROOT/ops/scripts"

if [ -f "$ROOT/.env" ]; then set -a; . "$ROOT/.env"; set +a; fi

PASS=0; FAIL=0
run() { echo "=== $1 ==="; if "$@"; then echo "OK: $1"; PASS=$((PASS+1)); else echo "FAIL: $1"; FAIL=$((FAIL+1)); fi; }

run python3 "$SCRIPTS/p67-inventory.py" "$GEN"
run python3 "$SCRIPTS/p67-time-anchor.py"
run python3 "$SCRIPTS/p67-e2e-validate.py" "$EVID/p67-correlation.json"
run python3 "$SCRIPTS/p67-endpoint-validate.py" "$EVID/p67-endpoint.json"
run python3 "$SCRIPTS/p67-openwork-validate.py" "$EVID/p67-openwork.json"
run python3 "$SCRIPTS/p67-retry-validate.py" "$EVID/p67-retry.json"

echo "=== secret-pattern scan (phase67) ==="
if bash "$SCRIPTS/secret-pattern-scan.sh" >/tmp/p67-secret-scan.txt 2>&1; then
  echo "scan ran"; grep -iE "phase67|p67-" /tmp/p67-secret-scan.txt | head -10 || echo "(no phase67 secret hits)"
else
  echo "FAIL secret scan"; FAIL=$((FAIL+1))
fi

echo; echo "=== P67 CI summary: PASS=$PASS FAIL=$FAIL ==="
exit $FAIL
