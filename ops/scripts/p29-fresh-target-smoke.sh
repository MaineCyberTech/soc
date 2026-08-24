#!/usr/bin/env bash
set -euo pipefail
: "${TARGET_PROFILE:?Set TARGET_PROFILE}"; ROOT=${ROOT:-/opt/mct-security-stack}; cd "$ROOT"
./scripts/ci/run-local-ci.sh
./ops/scripts/secret-pattern-scan.sh
python3 ops/scripts/p28-dependency-graph.py "$ROOT" >/tmp/p29-service-graph-check.json
[ -s /tmp/p29-service-graph-check.json ]
echo 'Static gates PASS. Runtime service-specific smoke commands must be supplied by the target profile/runbook.'
