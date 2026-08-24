#!/usr/bin/env bash
# zeek-classa-guardrail.sh - hard rate-limit + kill switch for Zeek Class A routing.
# Counts Shuffle workflow executions (real posts) in the last 24h; if >= LIMIT, disables
# the Wazuh Zeek Class A integration (kill switch) and notifies. Also supports manual
# enable/disable. Runs via cron (every 15 min).
# Usage: bash ops/scripts/zeek-classa-guardrail.sh [check|disable|enable]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
ENV_FILE="$ROOT/.env"
STATE="$ROOT/ops/reports/zeek-classa-guardrail-state.log"
LIMIT=5
WF_ID="eb937a37-5244-46dc-95ff-62ad4c681322"
MANAGER_CONF="/opt/wazuh-docker/multi-node/config/wazuh_cluster/wazuh_manager.conf"
INT_MARKER="Zeek Class A (SSH/SMB/RDP)"
MODE="${1:-check}"
NOTIFY=""
[ -f "$ENV_FILE" ] && set -a && source "$ENV_FILE" && set +a
[ -f /opt/wazuh-docker/multi-node/ops/creds.env ] && set -a && source /opt/wazuh-docker/multi-node/ops/creds.env && set +a
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

count_last_24h() {
  local count
  count=$(curl -s -m 15 -H "Authorization: Bearer ${SHUFFLE_API_KEY:-}" \
    -H "X-Org-Id: ${SHUFFLE_ORG_ID:-}" \
    "http://127.0.0.1:3001/api/v1/workflows/${WF_ID}/executions?limit=100" 2>/dev/null \
    | python3 -c "
import json,sys,time
try:
    d=json.load(sys.stdin)
    ex = d if isinstance(d,list) else d.get('data',[])
    cutoff = time.time() - 86400
    n = sum(1 for e in ex if e.get('started_at',0) > cutoff and e.get('status')=='FINISHED')
    print(n)
except Exception:
    print(-1)
" 2>/dev/null)
  echo "${count:-0}"
}

integration_enabled() {
  grep -q '<rule_id>122001,122002,122003</rule_id>' "$MANAGER_CONF" 2>/dev/null && echo 1 || echo 0
}

disable_integration() {
  if [ "$(integration_enabled)" = "1" ]; then
    printf '%s\n' "${SUDO_PASSWORD:-}" | sudo -S python3 -c "
p='$MANAGER_CONF'
s=open(p).read()
start=s.find('  <!-- Zeek Class A (SSH/SMB/RDP)')
if start < 0: start=s.find('  <integration>\n    <name>custom-json-output</name>')
if start >= 0:
    end=s.find('  </integration>', start)
    if end < 0: end=len(s)
    block=s[start:end+len('  </integration>')]
    if 'DISABLED BY GUARDRAIL' not in block:
        s=s[:start]+'  <!-- DISABLED BY GUARDRAIL: Zeek Class A integration (kill switch) -->\n'+block.replace('  <integration>','  <!-- <integration>',1).replace('  </integration>','  </integration> -->',1)+s[end+len('  </integration>'):]
        open(p,'w').write(s)
        print('disabled block')
    else:
        print('already disabled')
" 2>/dev/null || return 1
    docker restart multi-node-wazuh.master-1 >/dev/null 2>&1
    sleep 12
    echo "$NOW KILL-SWITCH engaged (limit ${LIMIT}/24h exceeded)" >> "$STATE"
  else
    echo "kill switch already engaged"
  fi
}

enable_integration() {
  printf '%s\n' "${SUDO_PASSWORD:-}" | sudo -S python3 -c "
p='$MANAGER_CONF'
s=open(p).read()
s=s.replace('  <!-- DISABLED BY GUARDRAIL: Zeek Class A integration (kill switch) -->\n','')
s=s.replace('  <!-- <integration>','  <integration>').replace('  </integration> -->','  </integration>')
open(p,'w').write(s)
print('enabled')
" 2>/dev/null
  docker restart multi-node-wazuh.master-1 >/dev/null 2>&1
  sleep 12
  echo "$NOW integration re-enabled (manual)" >> "$STATE"
}

case "$MODE" in
  disable) disable_integration; echo "disabled"; exit 0 ;;
  enable)  enable_integration;  echo "enabled";  exit 0 ;;
  check|"") ;;
  *) echo "usage: $0 [check|disable|enable]"; exit 2 ;;
esac

COUNT=$(count_last_24h)
echo "[$NOW] zeek-classa executions last 24h: $COUNT (limit $LIMIT)"
if [ "$COUNT" -ge "$LIMIT" ]; then
  if [ "$(integration_enabled)" = "1" ]; then
    disable_integration
    echo "KILL SWITCH ENGAGED - $COUNT executions >= $LIMIT; integration disabled; operator notify required."
  else
    echo "integration already disabled (kill switch held)"
  fi
else
  echo "OK - under limit; integration enabled: $(integration_enabled)"
fi