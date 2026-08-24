#!/usr/bin/env bash
set -euo pipefail
ROOTS=${ROOTS:-"/opt/mct-security-stack /opt/wazuh-docker/multi-node"}; OUT=${OUT:-/tmp/p29-image-lock-$(date +%Y%m%d-%H%M%S).txt}
for root in $ROOTS; do echo "## $root"; grep -RInE '^[[:space:]]*image:[[:space:]]*' "$root" --include='*.yml' --include='*.yaml' 2>/dev/null || true; done > "$OUT"
echo "Wrote $OUT"
