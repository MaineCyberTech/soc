#!/usr/bin/env bash
set -euo pipefail
IFACE=${CAPTURE_IFACE:-ens19}; EVE=${EVE_STATS_FILE:-/var/log/suricata/eve.json}; OUT=${OUT:-/tmp/p34-zero-alert-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
systemctl is-active suricata > "$OUT/service.txt"
ip -s link show "$IFACE" > "$OUT/interface.txt"
ethtool -S "$IFACE" > "$OUT/nic.txt" 2>&1 || true
stat "$EVE" > "$OUT/eve-stat.txt" 2>&1 || true
systemctl show suricata -p MemoryCurrent -p MemoryPeak -p CPUUsageNSec > "$OUT/resources.txt"
echo "Wrote $OUT"
