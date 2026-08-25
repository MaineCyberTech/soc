#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; cd "$ROOT"
./scripts/ci/run-local-ci.sh
./ops/scripts/secret-pattern-scan.sh
./ops/scripts/p29-image-ci-gate.sh
./ops/scripts/p29-executable-mode-audit.sh
grep -RIn 'v1.3.0' README.md RELEASE-NOTES.md config 2>/dev/null >/tmp/p33-release-refs.txt
[ -s /tmp/p33-release-refs.txt ]; echo 'PASS release provenance local gates'
