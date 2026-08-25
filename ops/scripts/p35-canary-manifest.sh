#!/usr/bin/env bash
set -euo pipefail
OUT=${OUT:-/tmp/p35-canary-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
cat > "$OUT/manifest.txt" <<EOF
sid=2027967
synthetic=true
packet_proof_required=true
downstream_replay_separate=true
production_action=prohibited
expected_route=test-group
created_utc=$(date -u +%FT%TZ)
EOF
sha256sum "$OUT/manifest.txt" > "$OUT/manifest.sha256"; echo "Wrote $OUT"
