#!/usr/bin/env bash
# render-env-summary.sh - print which env vars are set (names only, no values).
# Usage: bash scripts/bootstrap/render-env-summary.sh
set -uo pipefail

echo "== Env summary $(date -u '+%Y-%m-%d %H:%M') =="
echo "(names + length only - never values)"

source /opt/wazuh-docker/multi-node/ops/creds.env 2>/dev/null
for var in WAZUH_ADMIN_PASSWORD WAZUH_REGISTRATION_PASSWORD PVE_HOST PVE_USERNAME \
  PVE_PASSWORD DO_SPACES_BUCKET DO_SPACES_ENDPOINT DO_SPACES_ACCESS_KEY \
  DO_SPACES_SECRET_KEY SO_SSH_USERNAME SO_SSH_PASSWORD SUDO_PASSWORD VIRUSTOTAL_API_KEY; do
  eval "val=\${$var:-}"
  if [ -n "$val" ]; then echo "  $var: set (${#val} chars)"; else echo "  $var: UNSET"; fi
done

echo "== Cloudflare tunnel (separate file) =="
[ -f /opt/wazuh-docker/multi-node/.env.cloudflare ] && echo "  .env.cloudflare: present" || echo "  .env.cloudflare: missing"
