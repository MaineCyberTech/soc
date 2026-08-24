#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; cd "$ROOT"
./scripts/ci/run-local-ci.sh
./ops/scripts/secret-pattern-scan.sh
bash /opt/mct-security-stack/ops/scripts/p29-image-ci-gate.sh
[ -z "$(git status --porcelain)" ] || { echo 'FAIL dirty tree'; exit 1; }
echo 'PASS Phase 30 code/security/image/repo gate'
