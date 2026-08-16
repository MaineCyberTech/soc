#!/usr/bin/env bash
# package-portable-repo.sh - dry-run by default; --apply creates the tarball.
# Packages only current source/docs (no secrets, no ops/backups, no data/).
# Usage: bash package-portable-repo.sh [--apply]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
OUT=/opt/mct-security-stack-backups/portable-repo
TS=$(date +%Y%m%d-%H%M%S)
APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1

INCLUDE=(
  README.md REPO-MAP.md ARCHITECTURE.md PORTABILITY.md SECURITY.md
  .env.example .gitignore.example
  config/examples scripts ops/runbooks ops/scripts ops/checklists
  ops/reports integrations reporting/templates reporting/generators
  reporting/output client-onboarding service-packaging evidence
  checklists compose
)

echo "== Portable repo package (dry-run: $([ $APPLY -eq 0 ] && echo YES || echo no-apply)) =="
echo "Source: $ROOT"
echo "Includes:"
for p in "${INCLUDE[@]}"; do
  if [ -e "$ROOT/$p" ]; then echo "  [OK] $p"; else echo "  [MISSING] $p"; fi
done

if [ $APPLY -eq 1 ]; then
  mkdir -p "$OUT"
  # copy excludes: use tar with excludes for safety
  tar czf "$OUT/mct-security-stack-portable-$TS.tar.gz" \
    --exclude='ops/backups' --exclude='data' --exclude='.env' \
    --exclude='ops/creds.env' --exclude='.env.cloudflare' \
    -C "$ROOT" "${INCLUDE[@]}" 2>/dev/null && echo "Created: $OUT/mct-security-stack-portable-$TS.tar.gz"
else
  echo "Dry run - no archive created. Use --apply to package."
fi
