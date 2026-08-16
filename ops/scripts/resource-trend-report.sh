#!/usr/bin/env bash
# resource-trend-report.sh
# Captures host memory/swap/disk and top container consumers into a report.
# Usage: resource-trend-report.sh [--out FILE]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
TS=$(date +%Y%m%d-%H%M%S)
OUT="${1:-$ROOT/ops/reports/resource-trend-$TS.md}"
mkdir -p "$ROOT/ops/reports"

{
  echo "# Resource Trend - $TS"
  echo
  echo "## Host"
  echo '```'
  free -h
  echo
  df -h / | tail -1
  echo
  uptime
  echo '```'
  echo
  echo "## Top container memory (docker stats, one-shot)"
  echo '```'
  docker stats --no-stream --format 'table {{.Name}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.CPUPerc}}' 2>/dev/null | sort -t$'\t' -k3 -hr | head -20
  echo '```'
  echo
  echo "## Swap pressure"
  echo '```'
  cat /proc/meminfo | grep -E 'SwapTotal|SwapFree|SwapCached'
  echo '```'
} > "$OUT"
echo "Wrote $OUT"
