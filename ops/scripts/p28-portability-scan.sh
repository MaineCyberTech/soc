#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; OUT=${OUT:-$ROOT/ops/reports/p28-portability-scan-$(date +%Y%m%d-%H%M%S).txt}; mkdir -p "$(dirname "$OUT")"
patterns='(/opt/|/home/|192\.168\.|10\.[0-9]+\.|latest|host\.docker\.internal|localhost|chmod 777|curl -k|--insecure|docker compose down -v|BEGIN .*PRIVATE KEY|password[=:])'
grep -RInE "$patterns" "$ROOT" --exclude-dir=.git --exclude-dir=ops/reports --include='*.sh' --include='*.py' --include='*.ps1' --include='*.yml' --include='*.yaml' --include='*.json' --include='*.xml' --include='*.conf' --include='*.md' 2>/dev/null > "$OUT" || true
echo "Wrote $OUT"
