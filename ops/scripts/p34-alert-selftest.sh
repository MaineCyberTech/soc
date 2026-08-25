#!/usr/bin/env bash
set -euo pipefail
: "${ALERT_RUNNER:?Set ALERT_RUNNER}"; OUT=${OUT:-/tmp/p34-alert-selftest-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
"$ALERT_RUNNER" > "$OUT/healthy.txt" 2>&1 || true
printf 'Self-test captures current-state execution only. Fault injection must follow the approved alert test matrix.
' > "$OUT/README.txt"
echo "Wrote $OUT"
