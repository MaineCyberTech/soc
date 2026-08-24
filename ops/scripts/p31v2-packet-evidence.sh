#!/usr/bin/env bash
set -euo pipefail
OUT=${OUT:-/tmp/p31v2-packet-evidence-$(date +%Y%m%d-%H%M%S)}; IFACE=${CAPTURE_IFACE:-eth0}; mkdir -p "$OUT"
systemctl status suricata --no-pager > "$OUT/service.txt" 2>&1 || true
systemctl show suricata -p ActiveState -p SubState -p MemoryCurrent -p MemoryPeak -p CPUUsageNSec > "$OUT/resources.txt" 2>&1 || true
suricata --build-info > "$OUT/build-info.txt" 2>&1 || true
suricata -T -c /etc/suricata/suricata.yaml > "$OUT/config-test.txt" 2>&1 || true
sha256sum /etc/suricata/suricata.yaml /etc/suricata/rules/*.rules > "$OUT/config-rules.sha256" 2>/dev/null || true
stat /var/log/suricata/eve.json > "$OUT/eve-stat.txt" 2>&1 || true
ip -s link show "$IFACE" > "$OUT/interface.txt" 2>&1 || true
ethtool -k "$IFACE" > "$OUT/offloads.txt" 2>&1 || true
free -h > "$OUT/free.txt"; df -hT > "$OUT/df.txt"; echo "Wrote $OUT"
