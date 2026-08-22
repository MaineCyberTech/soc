#!/usr/bin/env bash
# check-unpinned-docker-images.sh - detect compose image refs without @sha256.
# Phase 22 policy: runtime-pin violations FAIL; classified exceptions warn (see
# ops/config/unpinned-image-exceptions.txt and docs/CONTAINER-IMAGE-POLICY.md).
# Usage: bash ops/scripts/check-unpinned-docker-images.sh
# Exits non-zero ONLY for violations not in the classification exceptions list.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
REPORT_DIR=${REPORT_DIR:-$ROOT/ops/reports}
EXCEPTIONS_FILE=${EXCEPTIONS_FILE:-$ROOT/ops/config/unpinned-image-exceptions.txt}
TS=$(date +%Y%m%d-%H%M%S)
OUT="$REPORT_DIR/check-unpinned-docker-images-$TS.md"
mkdir -p "$REPORT_DIR"

# Allowed unpinned baseline (versioned tags - acceptable)
ALLOWED="alpine:|mariadb:|postgres:|redis:|valkey:|opensearchproject/|wazuh/wazuh-"

# Compose files scanned: MCT stack compose + Wazuh multi-node compose (P21 coverage fix).
COMPOSE_FILES=""
for d in "$ROOT/compose" "$ROOT/../wazuh-docker/multi-node"; do
  [ -d "$d" ] && COMPOSE_FILES="$COMPOSE_FILES $d"/*.yml
done
[ -z "$COMPOSE_FILES" ] && COMPOSE_FILES="$ROOT"/compose/*.yml

UNPINNED=$(grep -hoE "image: [^ #]+" $COMPOSE_FILES 2>/dev/null \
  | awk '{print $2}' | grep -v "@sha256" | sort -u)

VIOLATIONS=""
EXCEPTIONS=""
while IFS= read -r img; do
  [ -z "$img" ] && continue
  if echo "$img" | grep -qE "$ALLOWED"; then continue; fi
  if [ -f "$EXCEPTIONS_FILE" ] && grep -qE "^$img( |$)" "$EXCEPTIONS_FILE"; then
    EXCEPTIONS="$EXCEPTIONS
  $img"
  else
    VIOLATIONS="$VIOLATIONS
  $img"
  fi
done <<< "$UNPINNED"

{
  echo "# Check Unpinned Docker Images - $TS"
  echo
  echo "## Violations (runtime-pin policy - must pin by digest)"
  if [ -z "$VIOLATIONS" ]; then echo "NONE - all unpinned refs are allowed/classified."; else echo "$VIOLATIONS"; fi
  echo
  echo "## Classified exceptions (feed/versioned/cache - warn only)"
  if [ -z "$EXCEPTIONS" ]; then echo "NONE"; else echo "$EXCEPTIONS"; fi
} > "$OUT"
echo "Wrote $OUT"

if [ -n "$VIOLATIONS" ]; then
  echo "VIOLATIONS FOUND (see $OUT)"
  exit 1
fi
echo "PASS (exceptions allowed per policy: $(echo -n "$EXCEPTIONS" | grep -c '^  ' || true))"
exit 0
