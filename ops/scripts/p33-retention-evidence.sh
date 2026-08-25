#!/usr/bin/env bash
set -euo pipefail
: "${OS_URL:?Set OS_URL}"; : "${OS_USER:?Set OS_USER}"; : "${OS_PASS:?Set OS_PASS}"; OUT=${OUT:-/tmp/p33-retention-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
for e in '_cluster/health' '_cat/indices?format=json&bytes=gb&s=index' '_cat/allocation?format=json&bytes=gb' '_nodes/stats/fs' '_all/_settings?filter_path=*.settings.index.blocks.*' '_plugins/_ism/explain/*'; do f=$(echo "$e"|tr '/?*&=' '_______'); curl -fsS -u "$OS_USER:$OS_PASS" "$OS_URL/$e" > "$OUT/$f.json"; done
df -hT > "$OUT/host-df.txt"; echo "Wrote $OUT"
