#!/usr/bin/env bash
set -euo pipefail
OUT=${OUT:-/tmp/p32-tmp-audit-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
df -h /tmp > "$OUT/space.txt"; df -i /tmp > "$OUT/inodes.txt"; find /tmp -xdev -printf '%u	%y	%T@	%s	%p
' 2>/dev/null > "$OUT/files.tsv"; du -x -h -d 2 /tmp 2>/dev/null | sort -h > "$OUT/usage.txt"; lsof +D /tmp > "$OUT/open-files.txt" 2>/dev/null || true; systemctl status systemd-tmpfiles-clean.timer --no-pager > "$OUT/tmpfiles-timer.txt" 2>&1 || true; echo "Wrote $OUT"
