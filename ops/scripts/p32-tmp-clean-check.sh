#!/usr/bin/env bash
set -euo pipefail
AGE_MINUTES=${AGE_MINUTES:-60}; ROOT=${TMP_ROOT:-/tmp}; OUT=${OUT:-/tmp/p32-clean-candidates-$(date +%Y%m%d-%H%M%S).txt}
find "$ROOT" -xdev -type f -mmin "+$AGE_MINUTES" -links 1 -print0 2>/dev/null | while IFS= read -r -d '' f; do lsof -- "$f" >/dev/null 2>&1 && continue; case "$f" in /tmp/.X11-unix/*|/tmp/.ICE-unix/*|/tmp/systemd-private-*/*) continue;; esac; stat -c '%U|%s|%y|%n' "$f"; done > "$OUT"; echo "CHECK ONLY wrote $OUT"
