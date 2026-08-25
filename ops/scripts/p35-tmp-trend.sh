#!/usr/bin/env bash
set -euo pipefail
OUT=${OUT:-/var/log/mct-tmp-trend.log}; space=$(df -P /tmp|awk 'NR==2{gsub(/%/,"",$5);print $5}'); inode=$(df -Pi /tmp|awk 'NR==2{gsub(/%/,"",$5);print $5}'); files=$(find /tmp -xdev -mindepth 1 2>/dev/null|wc -l); printf '%s space_pct=%s inode_pct=%s files=%s
' "$(date -u +%FT%TZ)" "$space" "$inode" "$files" >> "$OUT"
