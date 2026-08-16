#!/usr/bin/env bash
# Phase 9 disk growth report - top consumers + 7-day snapshot growth trend.
# Usage: bash disk-growth-report.sh
set -uo pipefail
source /opt/wazuh-docker/multi-node/ops/creds.env 2>/dev/null

echo "=== Disk usage (top-level) $(date -u '+%Y-%m-%d %H:%M') ==="
df -h / | tail -1

echo
echo "=== Top 12 directories ==="
du -x --max-depth=1 /opt /var/lib/docker 2>/dev/null | sort -rh | head -12

echo
echo "=== /opt/wazuh-backups breakdown ==="
du -sh /opt/wazuh-backups/* 2>/dev/null | sort -rh | head -8

echo
echo "=== OpenSearch index storage (top 10) ==="
if command -v curl >/dev/null && [ -n "${WAZUH_ADMIN_PASSWORD:-}" ]; then
  curl -sk -m 10 "https://localhost:9200/_cat/indices?h=index,pri.store.size&s=pri.store.size:desc" \
    -u "admin:${WAZUH_ADMIN_PASSWORD}" 2>/dev/null | head -10
fi

echo
echo "=== Snapshot growth (last 10 local snapshots, oldest->newest) ==="
ls -lat /opt/wazuh-backups/elasticsearch/snap-*.dat 2>/dev/null | tail -10 | awk '{print $5, $9}'

echo
echo "=== Swap pressure ==="
free -h | grep -E "Mem|Swap"
