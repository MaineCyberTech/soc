#!/usr/bin/env bash
# Endpoint count report - Wazuh agents by group + Velociraptor clients.
# Usage: bash endpoint-count-report.sh
# Never prints secrets.
set -uo pipefail
source /opt/wazuh-docker/multi-node/ops/creds.env 2>/dev/null
: "${WAZUH_WUI_PASSWORD:?WAZUH_WUI_PASSWORD not set in creds.env}"

echo "=== Endpoint count report $(date -u '+%Y-%m-%d %H:%M') ==="
echo

echo "--- Wazuh agents (by group) ---"
docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l 2>/dev/null | \
  awk '/ID:/{id=$2; name=$4; status=$6; if (name!="Name:") print id, name, status}' | \
  sort -u | head -20

echo
echo "--- Wazuh agent counts (via API) ---"
TOKEN=$(curl -sk -m 10 -u "wazuh-wui:${WAZUH_WUI_PASSWORD}" -X POST "https://localhost:55000/security/user/authenticate" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin).get('data',{}).get('token',''))" 2>/dev/null)
if [ -n "$TOKEN" ]; then
  curl -sk -m 10 "https://localhost:55000/agents?pretty=false" -H "Authorization: Bearer $TOKEN" 2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin).get('data',{}).get('affected_items',[])
from collections import Counter
total=len(d)
active=sum(1 for a in d if a.get('status')=='active')
print(f'total agents: {total}')
print(f'active: {active}')
groups=Counter()
for a in d:
    for g in (a.get('group') or []):
        groups[g]+=1
print('by group:', dict(groups))
"
fi

echo
echo "--- Velociraptor clients ---"
if [ -f /tmp/opencode/phase9-api.yaml ]; then
  /tmp/opencode/velociraptor --config /opt/mct-security-stack/data/velociraptor/server.config.yaml \
    --api_config /tmp/opencode/phase9-api.yaml query \
    "SELECT client_id, os_info.system FROM clients()" 2>/dev/null | \
    python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    print('velociraptor clients:', len(d))
    for c in d: print(' ', c.get('client_id'), c.get('os_info',{}).get('system'))
except: print('velociraptor query unavailable')
"
else
  echo "api config not present - skip"
fi
