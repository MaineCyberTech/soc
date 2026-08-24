#!/usr/bin/env bash
set -euo pipefail
: "${EVIDENCE_DIR:?Set EVIDENCE_DIR}"; OUT=${OUT:-/tmp/mct-p29-deploy-evidence.tar.gz}
find "$EVIDENCE_DIR" -type f -print0 | sort -z | xargs -0 sha256sum > "$EVIDENCE_DIR/manifest.sha256"
tar --sort=name --mtime='UTC 2026-01-01' --owner=0 --group=0 --numeric-owner -czf "$OUT" -C "$EVIDENCE_DIR" .
sha256sum "$OUT"; echo "Wrote $OUT"
