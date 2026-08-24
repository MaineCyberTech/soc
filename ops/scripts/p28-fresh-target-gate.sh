#!/usr/bin/env bash
set -euo pipefail
: "${TARGET_PROFILE:?Set TARGET_PROFILE}"; ROOT=${ROOT:-/opt/mct-security-stack}; cd "$ROOT"
./scripts/ci/run-local-ci.sh
./ops/scripts/secret-pattern-scan.sh
find . -type f -name '*.sh' -print0 | xargs -0 -n1 bash -n
find . -type f -name '*.py' -print0 | xargs -0 -n1 env PYTHONPYCACHEPREFIX=/tmp/mct-p28-pyc python3 -m py_compile
[ -f "config/profiles/$TARGET_PROFILE" ] || { echo 'Missing target profile'; exit 2; }
echo 'PASS code/config pre-deployment gates. Runtime deployment still requires an isolated target.'
