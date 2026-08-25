#!/usr/bin/env bash
set -euo pipefail
OUT=${OUT:-/tmp/p33-observe-$(date +%Y%m%d-%H%M%S)}; IFACE=${CAPTURE_IFACE:-ens19}; mkdir -p "$OUT"
date -u +%FT%TZ > "$OUT/timestamp.txt"
systemctl show mct-suricata -p ActiveState -p SubState -p MemoryCurrent -p MemoryPeak -p CPUUsageNSec > "$OUT/suricata-service.txt" 2>&1 || true
ip -s link show "$IFACE" > "$OUT/interface.txt" 2>&1 || true
ethtool -S "$IFACE" > "$OUT/nic-stats.txt" 2>&1 || true
stat /var/log/suricata/eve-alert.json > "$OUT/eve-stat.txt" 2>&1 || true
free -h > "$OUT/free.txt"; cat /proc/pressure/memory > "$OUT/psi.txt" 2>/dev/null || true; df -hT > "$OUT/df.txt"
echo "Wrote $OUT"
