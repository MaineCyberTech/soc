#!/usr/bin/env bash
set -euo pipefail
: "${SERVICE:?Set SERVICE}"; : "${DURATION_SECONDS:=300}"; OUT=${OUT:-/tmp/p31-sensor-benchmark-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
for n in $(seq 1 "$DURATION_SECONDS"); do
 ts=$(date -u +%FT%TZ)
 systemctl show "$SERVICE" -p ActiveState -p SubState -p MemoryCurrent -p MemoryPeak -p CPUUsageNSec 2>/dev/null | tr '\n' ' ' | sed "s/^/$ts /" >> "$OUT/service.csv" || true
 ps -C suricata -o pid,rss,%mem,%cpu,etime --no-headers >> "$OUT/process.txt" 2>/dev/null || true
 [ $((n%30)) -eq 0 ] && vmstat 1 2 >> "$OUT/vmstat.txt"
 sleep 1
done
free -h > "$OUT/free-final.txt"; cat /proc/pressure/memory > "$OUT/psi-final.txt" 2>/dev/null || true
echo "Wrote $OUT"
