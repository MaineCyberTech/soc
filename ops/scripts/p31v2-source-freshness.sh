#!/usr/bin/env bash
set -euo pipefail
: "${SOURCE_FILE:?Set SOURCE_FILE}"; MAX=${MAX_AGE_SECONDS:-300}; [ -e "$SOURCE_FILE" ] || exit 2
age=$(($(date +%s)-$(stat -c %Y "$SOURCE_FILE"))); echo "age=$age max=$MAX file=$SOURCE_FILE"; [ "$age" -le "$MAX" ]
