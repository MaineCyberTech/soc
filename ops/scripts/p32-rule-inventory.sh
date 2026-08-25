#!/usr/bin/env bash
set -euo pipefail
OUT=${OUT:-/tmp/p32-rule-inventory-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
suricata-update list-enabled-sources > "$OUT/enabled-sources.txt" 2>&1 || true
suricata-update list-sources > "$OUT/all-sources.txt" 2>&1 || true
find /etc/suricata /var/lib/suricata/rules -type f \( -name '*.rules' -o -name 'enable.conf' -o -name 'disable.conf' -o -name 'modify.conf' -o -name 'threshold.config' \) -print -exec sha256sum {} \; > "$OUT/files-hashes.txt" 2>/dev/null || true
grep -RhoE 'sid:[[:space:]]*[0-9]+' /etc/suricata /var/lib/suricata/rules 2>/dev/null | sed -E 's/.*sid:[[:space:]]*//' | sort | uniq -c | sort -nr > "$OUT/sid-counts.txt"
echo "Wrote $OUT"
