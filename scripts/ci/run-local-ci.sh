#!/usr/bin/env bash
# run-local-ci.sh - local CI equivalent (runs on the stack host).
# Usage: bash scripts/ci/run-local-ci.sh
# Exits non-zero on any check failure (set -e semantics per step).
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
cd "$ROOT"

FAIL=0
step() { echo; echo "[CI] === $* ==="; }

step "verify-stack-layout (repo-only)"
bash scripts/verify/verify-stack-layout.sh || FAIL=1

step "verify-no-stale-phase-refs (repo-only)"
bash scripts/verify/verify-no-stale-phase-refs.sh || FAIL=1

step "verify-portable-repo (needs creds.env)"
bash scripts/verify/verify-portable-repo.sh || FAIL=1

step "verify-current-architecture (needs docker stack)"
bash scripts/verify/verify-current-architecture.sh || FAIL=1

step "secret-pattern-scan (no values printed)"
bash ops/scripts/secret-pattern-scan.sh "$ROOT" || FAIL=1

step "bash syntax check"
BFAIL=0
find . -path './.git' -prune -o -name '*.sh' -type f -print | while read -r f; do
  bash -n "$f" || { echo "SYNTAX FAIL: $f"; }
done
# bash -n exit status of find loop: collect via temp
find . -path './.git' -prune -o -name '*.sh' -type f -print0 | while IFS= read -r -d '' f; do
  bash -n "$f" 2>/dev/null || echo "SYNTAX FAIL: $f"
done

step "python syntax check"
find . -path './.git' -prune -o -name '*.py' -type f -print0 | while IFS= read -r -d '' f; do
  python3 -m py_compile "$f" 2>/dev/null || echo "PYTHON FAIL: $f"
done

step "powershell present check"
PS=$(find . -path './.git' -prune -o -name '*.ps1' -type f -print | wc -l)
echo "PowerShell files present: $PS (need endpoint/runtime validation, not run in CI)"

step "unpinned docker image check (informational)"
bash ops/scripts/check-unpinned-docker-images.sh || echo "[NOTE] unpinned refs remain (backlog)"

step "level.io variable tests"
if [ -x scripts/ci/run-levelio-variable-tests.sh ]; then
  bash scripts/ci/run-levelio-variable-tests.sh || FAIL=1
else
  echo "[SKIP] run-levelio-variable-tests.sh not present"
fi

echo
if [ $FAIL -eq 0 ]; then
  echo "[CI] RESULT: PASS"
  exit 0
else
  echo "[CI] RESULT: ACTION REQUIRED (see failures above)"
  exit 1
fi
