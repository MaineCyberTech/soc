#!/usr/bin/env bash
set -euo pipefail
STATE=${STATE_DIR:-/var/lib/mct-alert-state}; mkdir -p "$STATE"
run(){ name=$1; shift; if "$@"; then now=HEALTHY; else now=FAILED; fi; old=$(cat "$STATE/$name" 2>/dev/null || echo UNKNOWN); if [ "$now" != "$old" ]; then printf '%s|%s|%s|%s
' "$(date -u +%FT%TZ)" "$name" "$old" "$now"; fi; echo "$now" > "$STATE/$name"; }
: "${EVE_FILE:=/var/log/suricata/eve.json}"
run suricata-service systemctl is-active --quiet mct-suricata
run eve-fresh env SOURCE_FILE="$EVE_FILE" MAX_AGE_SECONDS=600 /usr/local/bin/p31v2-source-freshness.sh
exit 0
