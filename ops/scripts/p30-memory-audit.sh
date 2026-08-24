#!/usr/bin/env bash
set -euo pipefail
OUT=${OUT:-/tmp/p30-memory-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
free -h > "$OUT/free.txt"; vmstat 1 30 > "$OUT/vmstat.txt"; cat /proc/pressure/memory > "$OUT/memory-psi.txt" 2>/dev/null || true
ps -eo pid,user,comm,rss,vsz,%mem,%cpu --sort=-rss > "$OUT/processes.txt"
for p in /proc/[0-9]*; do awk '/^Name:/{n=$2}/^VmRSS:/{r=$2}/^VmSwap:/{s=$2}END{if(s>0)print s,r,n}' "$p/status" 2>/dev/null; done | sort -nr > "$OUT/process-swap-kb.txt"
docker stats --no-stream > "$OUT/docker-stats.txt" 2>/dev/null || true
dmesg -T | grep -Ei 'oom|out of memory|memory pressure|kswapd' > "$OUT/kernel-memory.txt" 2>/dev/null || true
echo "Wrote $OUT"
