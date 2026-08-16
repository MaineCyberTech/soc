#!/usr/bin/env bash
# resource-efficiency-report.sh - capture host/container/disk resource usage.
# Usage: bash ops/scripts/resource-efficiency-report.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
REPORT_DIR=${REPORT_DIR:-$ROOT/ops/reports}
TS=$(date +%Y%m%d-%H%M%S)
OUT="$REPORT_DIR/resource-efficiency-report-$TS.md"
mkdir -p "$REPORT_DIR"

{
  echo "# Resource Efficiency Report - $TS"
  echo
  echo "## Host"
  free -h
  echo
  df -h / /opt 2>/dev/null
  echo
  echo "## Docker containers (top 10 by memory)"
  docker stats --no-stream --format "{{.Name}}\t{{.MemUsage}}\t{{.CPUPerc}}" 2>/dev/null \
    | sort -t$'\t' -k2 -rh | head -10
  echo
  echo "## Top disk consumers (/opt)"
  du -xh /opt 2>/dev/null | sort -h | tail -12
  echo
  echo "## ES snapshots (local repo)"
  du -sh /opt/wazuh-backups/elasticsearch 2>/dev/null
  ls /opt/wazuh-backups/elasticsearch 2>/dev/null | wc -l | xargs echo "  entries:"
} > "$OUT"
echo "Wrote $OUT"
