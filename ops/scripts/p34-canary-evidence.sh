#!/usr/bin/env bash
set -euo pipefail
OUT=${OUT:-/tmp/p34-canary-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
printf 'SID=2027967
synthetic=true
expected_route=test-group
production_action=prohibited
' > "$OUT/expected.txt"
echo 'Populate this evidence directory only from approved canary execution outputs.' > "$OUT/README.txt"
echo "Wrote $OUT"
