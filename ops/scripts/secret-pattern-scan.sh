#!/usr/bin/env bash
# secret-pattern-scan.sh - scan repo for likely secrets (file/line/category only).
# Usage: bash secret-pattern-scan.sh
# NEVER prints values.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
echo "== Secret pattern scan $(date -u '+%Y-%m-%d %H:%M') =="
echo "(prints file:line:category only - never values)"
echo

scan_dir() {
  local dir=$1
  find "$dir" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.env*" -o -name "*.conf" \) \
    ! -path "*/ops/backups/*" ! -path "*/data/*" ! -path "*/.git/*" ! -path "*/evidence/*" \
    ! -path "*/ops/reports/*" \
    ! -name "ingest-pipeline-inventory-*.md" ! -name "hardcoded-brand-scan-*.md" \
    ! -name "self-contained-completeness-check-*.md" \
    ! -name "secret-pattern-scan.sh" ! -name "scan-docs-for-secret-patterns.sh" 2>/dev/null | while read -r f; do
    grep -HnE "(password|passwd|secret|api[_-]?key|token|private[_-]?key|BEGIN [A-Z ]*PRIVATE KEY|AKIA[0-9A-Z]{16}|DO00[0-9A-Z]{14})[[:space:]]*[=:][[:space:]]*[^[:space:]<]" "$f" 2>/dev/null \
      | sed -E 's/(password|passwd|secret|api[_-]?key|token|private[_-]?key|AKIA[0-9A-Z]{16}|DO00[0-9A-Z]{14})[[:space:]]*[=:][[:space:]]*.*/\1/' \
      | awk -v F="$f" '{print F ":" NR ":" $NF}'
  done
}

# summarize by category, suppress values
scan_dir "$ROOT" | sed -E 's/:[0-9]+:[^:]*$/:<value-hidden>/' | sort | uniq -c | sort -rn | head -30

echo
echo "== Scan complete. Review hits; expected false positives: .env.example, secrets.example.env, docs citing variable names. =="
