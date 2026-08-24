#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; OUT=${OUT:-$ROOT/ops/reports/p28-consolidation-candidates-$(date +%Y%m%d-%H%M%S).txt}; mkdir -p "$(dirname "$OUT")"
find "$ROOT" -type f -printf '%f\t%p\n' | sort | awk -F'\t' 'prev==$1{print prevpath; print $2} {prev=$1;prevpath=$2}' | sort -u > "$OUT"
echo "Wrote $OUT; same-name files are candidates, not automatic duplicates."
