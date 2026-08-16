#!/usr/bin/env bash
# shuffle-workflow-export.sh
# Exports Shuffle workflows (backend) to ops/backups/shuffle-workflows.
# Uses backend API without printing secrets.
# Usage: shuffle-workflow-export.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
TS=$(date +%Y%m%d-%H%M%S)
DEST="$ROOT/ops/backups/shuffle-workflows"
mkdir -p "$DEST"

echo "== Shuffle workflow export $TS =="

if ! docker ps --format '{{.Names}}' | grep -q '^shuffle-backend$'; then
  echo "ERROR: shuffle-backend not running"
  exit 1
fi

# API key from protected env (never printed)
set -a; source "$ROOT/.env" 2>/dev/null; set +a
SHUFFLE_API_KEY="${SHUFFLE_API_KEY:-}"

# Try API export (needs auth); fall back to documented UI export path
OUT="$DEST/shuffle-workflows-$TS.json"
fetch() {
  if [ -n "$SHUFFLE_API_KEY" ]; then
    docker exec shuffle-backend sh -lc "wget -q -O- --timeout=10 --header='Authorization: Bearer ${SHUFFLE_API_KEY}' \"http://localhost:5001/api/v1/workflows?limit=1000\" 2>/dev/null"
  else
    docker exec shuffle-backend sh -lc 'wget -q -O- --timeout=10 "http://localhost:5001/api/v1/workflows?limit=1000" 2>/dev/null'
  fi
}
if fetch | head -c 1000 | grep -qE '^\[|^\{'; then
  fetch > "$OUT"
  if [ -s "$OUT" ]; then
    echo "OK: $OUT ($(wc -c < "$OUT") bytes)"
  else
    echo "WARN: API returned empty - use Shuffle UI export manually (Workflows -> Export)"
    rm -f "$OUT"
  fi
else
  echo "WARN: backend API export unavailable (401 without key?) - use Shuffle UI export manually; set SHUFFLE_API_KEY in .env for automation"
fi

# retention: keep 14
ls -t "$DEST"/shuffle-workflows-*.json 2>/dev/null | tail -n +15 | xargs -r rm -f
echo "Done"
