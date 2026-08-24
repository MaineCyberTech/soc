#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; OUT=${OUT:-$ROOT/ops/reports/p28-deployability-inventory-$(date +%Y%m%d-%H%M%S).txt}; mkdir -p "$(dirname "$OUT")"
{
 echo '# files'; find "$ROOT" -xdev -type f | sort
 echo '# compose'; find "$ROOT" -type f \( -name 'docker-compose*.yml' -o -name 'compose*.yaml' \) | sort
 echo '# scripts'; find "$ROOT" -type f \( -name '*.sh' -o -name '*.py' -o -name '*.ps1' \) | sort
 echo '# service refs'; grep -RInE 'systemctl|cron|crontab|docker compose|ports:|image:|volume|webhook|allowed-ips|192\.168\.|/opt/' "$ROOT" --include='*.md' --include='*.sh' --include='*.py' --include='*.ps1' --include='*.yml' --include='*.yaml' --include='*.conf' 2>/dev/null || true
} > "$OUT"; echo "Wrote $OUT"
