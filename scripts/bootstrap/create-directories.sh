#!/usr/bin/env bash
# create-directories.sh - ensure portable repo dirs exist (idempotent).
# Usage: bash scripts/bootstrap/create-directories.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
DIRS=(
  config/examples scripts/bootstrap scripts/verify scripts/endpoint-deploy
  ops/runbooks ops/scripts ops/checklists ops/reports
  integrations reporting/templates reporting/generators reporting/output/client
  reporting/output/internal client-onboarding/templates service-packaging
  evidence/reports checklists compose
)
for d in "${DIRS[@]}"; do
  mkdir -p "$ROOT/$d"
done
echo "Directories ensured: $(ls -d "$ROOT"/*/ | wc -l) top-level + nested"
