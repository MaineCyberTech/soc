#!/bin/bash
set -euo pipefail
OUTDIR="${1:-$PWD}"; TS=$(date -u +%Y%m%dT%H%M%SZ); OUT="$OUTDIR/agent015-diagnostics-$TS.txt"; CONF="${WAZUH_OSSEC_CONF:-/Library/Ossec/etc/ossec.conf}"; LOG="${WAZUH_LOG:-/Library/Ossec/logs/ossec.log}"
{ echo "timestamp=$(date -u +%FT%TZ)"; sw_vers 2>/dev/null || true; uname -m; pgrep -alf 'wazuh-agentd|ossec-agentd' || true; grep -n 'MCT-PHASE22-BOUNDED-MACOS\|<location>macos\|<query>' "$CONF" 2>/dev/null || true; tail -n 300 "$LOG" 2>/dev/null | grep -Ei 'queue|connected|error|warning|started' || true; du -sh /Library/Ossec/queue 2>/dev/null || true; } > "$OUT"
chmod 600 "$OUT"; echo "Wrote $OUT (review before sharing)"
