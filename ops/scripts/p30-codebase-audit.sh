#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; OUT=${OUT:-$ROOT/ops/reports/p30-codebase-audit-$(date +%Y%m%d-%H%M%S).md}; mkdir -p "$(dirname "$OUT")"; FAIL=0
{
 echo '# Phase 30 Codebase Audit'
 echo '## Git'; git -C "$ROOT" status --short; git -C "$ROOT" ls-files | wc -l
 echo '## Shell'
 while IFS= read -r f; do bash -n "$f" || { echo "FAIL $f"; FAIL=1; }; done < <(find "$ROOT" -type f -name '*.sh')
 echo '## Python'
 while IFS= read -r f; do PYTHONPYCACHEPREFIX=/tmp/p30-pyc python3 -m py_compile "$f" || { echo "FAIL $f"; FAIL=1; }; done < <(find "$ROOT" -type f -name '*.py')
 echo '## PowerShell inventory'; find "$ROOT" -type f -name '*.ps1' | sort
 echo '## Config inventory'; find "$ROOT" -type f \( -name '*.xml' -o -name '*.yml' -o -name '*.yaml' -o -name '*.json' -o -name '*.conf' \) | sort
} > "$OUT"; echo "Wrote $OUT"; exit "$FAIL"
