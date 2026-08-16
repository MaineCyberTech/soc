#!/usr/bin/env bash
# check-unpinned-docker-images.sh - detect compose image refs without @sha256.
# Usage: bash ops/scripts/check-unpinned-docker-images.sh
# Exits non-zero if unpinned refs found beyond the allowed baseline.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
REPORT_DIR=${REPORT_DIR:-$ROOT/ops/reports}
TS=$(date +%Y%m%d-%H%M%S)
OUT="$REPORT_DIR/check-unpinned-docker-images-$TS.md"
mkdir -p "$REPORT_DIR"

# Allowed unpinned baseline (versioned tags - acceptable)
ALLOWED="alpine:|mariadb:|postgres:|redis:|valkey:|opensearchproject/"

UNPINNED=$(grep -hoE "image: [^ #]+" "$ROOT"/compose/*.yml 2>/dev/null \
  | awk '{print $2}' | grep -v "@sha256" | sort -u)

VIOLATIONS=""
while IFS= read -r img; do
  [ -z "$img" ] && continue
  if ! echo "$img" | grep -qE "$ALLOWED"; then
    VIOLATIONS="$VIOLATIONS
  $img"
  fi
done <<< "$UNPINNED"

{
  echo "# Check Unpinned Docker Images - $TS"
  echo
  echo "## Unpinned refs (excl. allowed versioned tags)"
  if [ -z "$VIOLATIONS" ]; then
    echo "NONE - all unpinned refs are versioned/allowed."
  else
    echo "$VIOLATIONS"
  fi
} > "$OUT"
echo "Wrote $OUT"

if [ -n "$VIOLATIONS" ]; then
  echo "VIOLATIONS FOUND (see $OUT)"
  exit 1
fi
echo "PASS"
exit 0
