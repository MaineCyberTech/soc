#!/usr/bin/env bash
# run-levelio-variable-tests.sh - run the Level.io variable simulation harness.
# Usage: bash scripts/ci/run-levelio-variable-tests.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
cd "$ROOT"

echo "== Level.io variable test harness =="

FAIL=0
if [ -x scripts/endpoint-deploy/test/simulate-levelio-linux.sh ]; then
  bash scripts/endpoint-deploy/test/simulate-levelio-linux.sh || FAIL=1
else
  echo "[SKIP] simulate-levelio-linux.sh not present"
fi

if command -v pwsh >/dev/null 2>&1 && [ -f scripts/endpoint-deploy/test/simulate-levelio-windows.ps1 ]; then
  pwsh -NoProfile -File scripts/endpoint-deploy/test/simulate-levelio-windows.ps1 || FAIL=1
else
  echo "[SKIP] pwsh not available - Windows simulation script presence checked only"
fi

echo
if [ $FAIL -eq 0 ]; then
  echo "== Result: PASS =="
  exit 0
else
  echo "== Result: ACTION REQUIRED =="
  exit 1
fi
