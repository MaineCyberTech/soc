#!/usr/bin/env bash
# pve-api-healthcheck.sh
# Validates PVE API access (read-only). Never prints credentials.
# Usage: pve-api-healthcheck.sh
set -uo pipefail

WAZUH=${WAZUH_STACK_ROOT:-/opt/wazuh-docker/multi-node}
if [[ -f "$WAZUH/ops/creds.env" ]]; then
  set -a; source "$WAZUH/ops/creds.env" 2>/dev/null; set +a
fi

FAIL=0
ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

echo "== PVE API healthcheck =="
echo "host: ${PVE_HOST:-unset} | user len: ${#PVE_USERNAME} | pw len: ${#PVE_PASSWORD}"
echo

# 1. Reachability
if timeout 4 bash -c "echo > /dev/tcp/${PVE_HOST:-192.168.222.187}/8006" 2>/dev/null; then
  ok "PVE API port 8006 reachable"
else
  bad "PVE API port 8006 unreachable"
fi

# 2. Auth (try realm variants; report which works without printing values)
AUTHED=0
for realm in "" "@pve" "@PAM" "@pam"; do
  user="${PVE_USERNAME}${realm}"
  code=$(curl -sk -m 6 -o /dev/null -w '%{http_code}' "https://${PVE_HOST:-192.168.222.187}:8006/api2/json/version" -u "$user:$PVE_PASSWORD" 2>/dev/null)
  [ "$code" = "200" ] && { ok "API auth works (realm: ${realm:-default})"; AUTHED=1; break; }
done
[ "$AUTHED" = "0" ] && bad "API auth failed (all realm variants 401/403) - creds stale"

# 3. Read-only ops if authed
if [ "$AUTHED" = "1" ]; then
  for op in "nodes" "cluster/resources?type=vm"; do
    code=$(curl -sk -m 6 -o /dev/null -w '%{http_code}' "https://${PVE_HOST}:8006/api2/json/$op" -u "$PVE_USERNAME@$PVE_REALM:$PVE_PASSWORD" 2>/dev/null)
    [ "$code" = "200" ] && ok "read-only op $op -> 200" || bad "read-only op $op -> $code"
  done
fi

# 4. SSH fallback
if timeout 6 ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=4 root@"${PVE_HOST:-192.168.222.187}" 'true' 2>/dev/null; then
  ok "SSH to PVE works (manual bypass available)"
else
  bad "SSH to PVE denied (no valid key) - manual bypass blocked"
fi

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
exit $FAIL
