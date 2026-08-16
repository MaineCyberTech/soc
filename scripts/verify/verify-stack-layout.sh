#!/usr/bin/env bash
# verify-stack-layout.sh - verify portable repo layout has required paths.
# Usage: bash scripts/verify/verify-stack-layout.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
FAIL=0
ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

echo "== Stack layout verify $(date -u '+%Y-%m-%d %H:%M') =="

REQUIRED=(
  README.md REPO-MAP.md ARCHITECTURE.md PORTABILITY.md SECURITY.md
  .env.example scripts/endpoint-deploy ops/runbooks ops/scripts ops/checklists
  ops/reports integrations client-onboarding service-packaging reporting/templates
  reporting/generators evidence
)
for p in "${REQUIRED[@]}"; do
  [ -e "$ROOT/$p" ] && ok "$p" || bad "$p MISSING"
done

echo "== Result: $([ $FAIL -eq 0 ] && echo PASS || echo ACTION REQUIRED) =="
exit $FAIL
