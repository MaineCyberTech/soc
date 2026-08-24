#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; OUT=${OUT:-$ROOT/ops/reports/p30-runtime-drift-$(date +%Y%m%d-%H%M%S).txt}; mkdir -p "$(dirname "$OUT")"
{
 echo '# desired images'; grep -RInE '^[[:space:]]*image:' "$ROOT" /opt/wazuh-docker/multi-node --include='*.yml' --include='*.yaml' 2>/dev/null || true
 echo '# running images'; docker ps --format '{{.Names}} {{.Image}} {{.ID}}' 2>/dev/null || true
 echo '# git executable modes'; git -C "$ROOT" ls-files -s '*.sh'
 echo '# modified/untracked'; git -C "$ROOT" status --short
} > "$OUT"; echo "Wrote $OUT"
