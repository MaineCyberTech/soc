#!/usr/bin/env bash
set -euo pipefail
: "${SOURCE_FILE:?Set SOURCE_FILE}"; MAX_AGE=${MAX_AGE_SECONDS:-300}
[ -e "$SOURCE_FILE" ] || { echo 'FAILED missing source'; exit 2; }
now=$(date +%s); mt=$(stat -c %Y "$SOURCE_FILE"); age=$((now-mt))
echo "age_seconds=$age max_age_seconds=$MAX_AGE file=$SOURCE_FILE"
[ "$age" -le "$MAX_AGE" ] || exit 1
