#!/usr/bin/env bash
# verify-no-stale-phase-refs.sh - scan current docs for stale phase/pack language.
# Usage: bash scripts/verify/verify-no-stale-phase-refs.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
echo "== Stale reference scan $(date -u '+%Y-%m-%d %H:%M') =="
echo "(current docs only; historical evidence excluded)"

HITS=$(find "$ROOT/ops/runbooks" "$ROOT/ops/checklists" "$ROOT/integrations" \
  "$ROOT/client-onboarding" "$ROOT/service-packaging" "$ROOT/reporting/templates" \
  -type f -name "*.md" \
  ! -path "*/evidence/*" ! -name "phase[0-8]-*" ! -name "phase9-*" ! -name "phase10-*" ! -name "phase11-*" \
  2>/dev/null | xargs grep -lE "phase 2|Phase 2 stack|phase 3 services|pack root|prompt pack" 2>/dev/null | wc -l)

if [ "$HITS" -eq 0 ]; then
  echo "[PASS] no stale phase/pack references in current docs"
  exit 0
else
  echo "[FAIL] $HITS files with stale references"
  find "$ROOT/ops/runbooks" "$ROOT/ops/checklists" "$ROOT/integrations" \
    "$ROOT/client-onboarding" "$ROOT/service-packaging" "$ROOT/reporting/templates" \
    -type f -name "*.md" ! -path "*/evidence/*" 2>/dev/null | xargs grep -lE "phase 2|Phase 2 stack|phase 3 services|pack root|prompt pack" 2>/dev/null | head -10
  exit 1
fi
