#!/usr/bin/env bash
# resource-post-change-validation.sh
# Validates capacity changes (e.g. RAM addition on PVE) with pass/fail checks.
# Usage: resource-post-change-validation.sh [--min-ram-gib 16]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
MIN_RAM="${1:-16}"
TS=$(date +%Y%m%d-%H%M%S)
OUT="$ROOT/ops/reports/resource-post-change-validation-$TS.md"
FAIL=0

ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

echo "== Resource post-change validation $TS =="

RAM_TOTAL=$(free -g | awk '/Mem:/ {print $2}')
SWAP_USED=$(free -m | awk '/Swap:/ {print $3}')
if [ "$RAM_TOTAL" -ge "$MIN_RAM" ]; then ok "RAM total ${RAM_TOTAL} GiB (>= ${MIN_RAM})"; else bad "RAM total ${RAM_TOTAL} GiB (< ${MIN_RAM})"; fi
if [ "$SWAP_USED" -lt 1024 ]; then ok "Swap used ${SWAP_USED} MiB (< 1 GiB)"; else bad "Swap used ${SWAP_USED} MiB (>= 1 GiB - pressure remains)"; fi

if /opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh >/dev/null 2>&1 && grep -q 'FAIL' /opt/mct-security-stack/ops/reports/full-stack-health-latest.md; then
  bad "full-stack healthcheck has FAIL"
else
  ok "full-stack healthcheck"
fi

{
  echo "# Resource Post Change Validation - $TS"
  echo
  echo "## Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
  echo
  echo '```'
  free -h
  echo
  df -h / | tail -1
  echo
  docker stats --no-stream --format 'table {{.Name}}\t{{.MemUsage}}\t{{.MemPerc}}' 2>/dev/null | sort -t$'\t' -k3 -hr | head -8
  echo '```'
} > "$OUT"

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
echo "Report: $OUT"
exit $FAIL
