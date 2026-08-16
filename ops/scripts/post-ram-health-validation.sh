#!/usr/bin/env bash
# post-ram-health-validation.sh - validate services after RAM expansion.
# Usage: bash post-ram-health-validation.sh
set -uo pipefail
source /opt/wazuh-docker/multi-node/ops/creds.env 2>/dev/null
FAIL=0
ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

echo "== Post-RAM health validation $(date -u '+%Y-%m-%d %H:%M') =="
echo
echo "--- Memory ---"
free -h | grep -E "Mem|Swap"
echo

echo "--- Services ---"
for c in multi-node-wazuh.master-1 multi-node-wazuh.worker-1 multi-node-wazuh1.indexer-1 multi-node-wazuh2.indexer-1 multi-node-wazuh3.indexer-1 multi-node-wazuh.dashboard-1 elastiflow flow-relay wazuh-cloudflared shuffle-backend shuffle-frontend iriswebapp_nginx; do
  if docker ps --format '{{.Names}}' | grep -q "^$c$"; then ok "$c"; else bad "$c not running"; fi
done

echo
echo "--- Indexer cluster ---"
IDX=$(curl -sk -m 8 -u "admin:${WAZUH_ADMIN_PASSWORD:-}" https://127.0.0.1:9200/_cluster/health 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin).get('status','?'))" 2>/dev/null)
[ "$IDX" = "green" ] && ok "indexer green" || bad "indexer status: $IDX"

echo
echo "--- Agents ---"
ACT=$(docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -l 2>/dev/null | grep -c Active)
[ "$ACT" -ge 5 ] && ok "agents active: $ACT" || bad "agents active: $ACT"

echo
echo "--- Velociraptor ---"
systemctl is-active velociraptor >/dev/null 2>&1 && ok "velociraptor active" || bad "velociraptor down"

echo
echo "=== Result: $([ $FAIL -eq 0 ] && echo PASS || echo ACTION REQUIRED) ==="
exit $FAIL
