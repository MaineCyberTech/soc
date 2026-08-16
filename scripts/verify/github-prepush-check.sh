#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}
cd "$ROOT"
echo "Running pre-push checks for mainecybertech/soc"
git status --short || true
[ -x scripts/ci/run-local-ci.sh ] && scripts/ci/run-local-ci.sh
printf '\nReview all reports before pushing. This script does not push.\n'
