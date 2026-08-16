#!/usr/bin/env bash
# pve222-api-healthcheck.sh - validates Proxmox 192.168.222.222 API access (read-only)
set -uo pipefail
WAZUH=${WAZUH_STACK_ROOT:-/opt/wazuh-docker/multi-node}
source "$WAZUH/ops/creds.env" 2>/dev/null
FAIL=0
ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }
HOST=192.168.222.222
echo "== Proxmox .222 API healthcheck =="
if timeout 4 bash -c "echo > /dev/tcp/$HOST/8006" 2>/dev/null; then ok "API port reachable"; else bad "API port unreachable"; fi
code=$(curl -sk -m 6 -o /tmp/opencode/p222.json -w '%{http_code}' -H "Authorization: PVEAPIToken=${PVE222_API_TOKEN:-}" "https://$HOST:8006/api2/json/version" 2>/dev/null)
if [ "$code" = "200" ]; then
  ver=$(python3 -c "import json;print(json.load(open('/tmp/opencode/p222.json')).get('data',{}).get('version','?'))" 2>/dev/null)
  ok "API auth works (PVE $ver)"
else
  bad "API auth failed ($code) - check PVE222_API_TOKEN in creds.env"
fi
node=$(curl -sk -m 6 -o /dev/null -w '%{http_code}' -H "Authorization: PVEAPIToken=${PVE222_API_TOKEN:-}" "https://$HOST:8006/api2/json/nodes/testnuc/qemu" 2>/dev/null)
[ "$node" = "200" ] && ok "VM list endpoint accessible" || bad "VM list endpoint denied ($node)"
echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
exit $FAIL
