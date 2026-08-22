#!/usr/bin/env bash
# render-virustotal-integration.sh - render the VirusTotal integration api_key into the
# Wazuh manager config from the protected creds.env, without tracking the value.
# Usage: bash ops/scripts/render-virustotal-integration.sh
# Idempotent: replaces the api_key line with the current value from VIRUSTOTAL_API_KEY.
# Never prints the value.
set -uo pipefail
WAZUH=${WAZUH_STACK_ROOT:-/opt/wazuh-docker/multi-node}
CONF="$WAZUH/config/wazuh_cluster/wazuh_manager.conf"
[ -f "$WAZUH/ops/creds.env" ] && set -a && source "$WAZUH/ops/creds.env" && set +a
: "${VIRUSTOTAL_API_KEY:?VIRUSTOTAL_API_KEY not set in ops/creds.env}"
[ -f "$CONF" ] || { echo "ERROR: $CONF not found" >&2; exit 3; }
cp -p "$CONF" "$CONF.bak-render.$(date -u +%Y%m%dT%H%M%SZ)"
python3 - "$CONF" "$VIRUSTOTAL_API_KEY" <<'EOF'
import re, sys
conf, key = sys.argv[1], sys.argv[2]
s = open(conf).read()
new, n = re.subn(r'(<api_key>)[^<]*(</api_key>)', rf'\1{key}\2', s)
if n == 0:
    print("ERROR: api_key element not found (integration block missing)"); sys.exit(1)
open(conf, 'w').write(new)
print(f"Updated api_key ({n} occurrence(s)); value not printed")
EOF
echo "Restart wazuh-analysisd to apply (manager restart)."