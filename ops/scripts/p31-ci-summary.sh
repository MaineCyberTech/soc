#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; cd "$ROOT"; rc=0
run(){ name=$1; shift; if "$@"; then echo "PASS|$name|none|No action"; else x=$?; echo "FAIL|$name|operator|Open linked runbook"; rc=$x; fi; }
run local-ci ./ops/scripts/run-local-ci.sh
run secret-scan ./ops/scripts/secret-pattern-scan.sh
run image-gate ./ops/scripts/p29-image-ci-gate.sh
run exec-mode ./ops/scripts/p29-executable-mode-audit.sh
exit "$rc"
