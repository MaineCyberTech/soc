#!/usr/bin/env bash
# verify-current-architecture.sh - verify live architecture facts.
# Usage: bash scripts/verify/verify-current-architecture.sh
set -uo pipefail
source /opt/wazuh-docker/multi-node/ops/creds.env 2>/dev/null

FAIL=0
ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

echo "== Architecture verify $(date -u '+%Y-%m-%d %H:%M') =="

# 1. remote syslog 15140 (not 514)
if docker port multi-node-wazuh.master-1 2>/dev/null | grep -q "15140"; then ok "remote syslog 15140 mapped"; else bad "15140 not mapped"; fi
if docker port multi-node-wazuh.master-1 2>/dev/null | grep -q ":514"; then bad "514 still mapped (should be retired)"; else ok "514 retired"; fi

# 2. SO packet ingestion -> agent 008 (RETIRED phase31; historical only, not a failure)
echo "  [RETIRED] agent 008 / Security Onion packet scanning retired (phase31) - not an active failure"

# 3. agents 011 + 012
for a in 011 012; do
  docker exec multi-node-wazuh.master-1 /var/ossec/bin/agent_control -i $a 2>/dev/null | grep -q Active && ok "agent $a Active" || bad "agent $a not active"
done

# 4. indexer green
IDX=$(curl -sk -m 8 -u "admin:${WAZUH_ADMIN_PASSWORD:-}" https://127.0.0.1:9200/_cluster/health 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin).get('status','?'))" 2>/dev/null)
[ "$IDX" = "green" ] && ok "indexer green" || bad "indexer: $IDX"

# 5. greenbone schedule doc exists
grep -q "MCT-lab-weekly-sun-0600" /opt/mct-security-stack/ARCHITECTURE.md 2>/dev/null && ok "greenbone schedule documented" || bad "schedule not in ARCHITECTURE"

echo "== Result: $([ $FAIL -eq 0 ] && echo PASS || echo ACTION REQUIRED) =="
exit $FAIL
