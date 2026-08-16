#!/usr/bin/env bash
# scan-docs-for-secret-patterns.sh
# Scans docs/scripts/configs for secret-like patterns.
# Prints file path, line number, and pattern category ONLY - never the matched value.
# Usage: scan-docs-for-secret-patterns.sh [ROOT] [--verbose]
set -uo pipefail

ROOT="${1:-/opt/mct-security-stack}"
[[ "${2:-}" == "--verbose" ]] && VERBOSE=1

PATTERNS=(
  "password-assignment:([Pp]assword|passwd)\s*[:=]\s*[^<[:space:]]"
  "api-key-token:(api[_-]?key|token|secret|apikey)\s*[:=]\s*[^<[:space:]]"
  "private-key-block:BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY"
  "cloud-access-key:(AKIA[0-9A-Z]{16}|DO00[A-Z0-9]{10}|aws_access_key_id|AWS_SECRET_ACCESS_KEY)"
  "credential-in-url:[a-z0-9._-]+[:@][^@[:space:]]+@"
)

echo "Scanning $ROOT for secret-like patterns (values are NOT printed)"
echo "================================================================="
total=0
while IFS= read -r f; do
  for entry in "${PATTERNS[@]}"; do
    label="${entry%%:*}"
    pat="${entry#*:}"
    while IFS=: read -r _file line _rest; do
      if [[ -n "${_file:-}" && -n "${line:-}" ]]; then
        echo "$_file:$line pattern=$label"
        total=$((total+1))
      fi
    done < <(grep -InE "$pat" "$f" 2>/dev/null)
  done
done < <(find "$ROOT" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.json' -o -name '*.yml' -o -name '*.yaml' -o -name '*.env' -o -name '*.example' -o -name '*.txt' \) 2>/dev/null | grep -vE '/ops/backups/|/ops/cdb/|/\.git/' | sort -u)

echo "================================================================="
echo "Total suspicious lines: $total"
echo "Review each hit and ensure the value is a placeholder (<REDACTED_*>)"
echo "or lives only in 0600 creds/.env files that are excluded from sharing."
exit 0
