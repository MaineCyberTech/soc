#!/bin/bash
set -euo pipefail
CONF="${WAZUH_OSSEC_CONF:-/Library/Ossec/etc/ossec.conf}"; LOG="${WAZUH_LOG:-/Library/Ossec/logs/ossec.log}"
echo "== Config =="; grep -n 'MCT-PHASE22-BOUNDED-MACOS\|<query>\|<location>macos' "$CONF" || true
echo "== Predicate control (Phase 24: post-upgrade check) =="
if grep -q 'MCT-PHASE22-BOUNDED-MACOS' "$CONF"; then
  echo "OK bounded marker present - agent upgrade preserved the bounded ULS predicate"
else
  echo "WARN bounded marker MISSING - agent upgrade may have rewritten ossec.conf; re-run: sudo ./repair-agent015-unified-log.sh --apply"
fi
echo "== Process =="; pgrep -alf 'wazuh-agentd|ossec-agentd' || true
echo "== Recent log =="; tail -n 100 "$LOG" 2>/dev/null | grep -Ei 'queue|connected|error|warning|started' || true
echo "== Queue size =="; du -sh /Library/Ossec/queue 2>/dev/null || true
echo "Server-side keepalive and 15m/1h/24h volume must also be checked."
