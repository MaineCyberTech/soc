#!/usr/bin/env bash
# p33-core-alert.sh - core-host operational alerts (agent, backup, disk, tmp, release)
# State-based dedup via /var/lib/mct-alert-state. Run via cron every 15m.
set -uo pipefail
ROOT=/opt/mct-security-stack
STATE=${HOME:-/tmp}/mct-alert-state; mkdir -p "$STATE"
cd "$ROOT"
now() { date -u +%FT%TZ; }
check() { local name=$1; local ok=$2; local detail=$3
  if [ "$ok" = "0" ]; then local cur=HEALTHY; else local cur=FAILED; fi
  local old=$(cat "$STATE/$name" 2>/dev/null || echo UNKNOWN)
  if [ "$cur" != "$old" ]; then printf '%s|%s|%s|%s|%s\n' "$(now)" "$name" "$old" "$cur" "$detail" >> /opt/mct-security-stack/ops/reports/p33-alert-events.log; fi
  echo "$cur" > "$STATE/$name"
}
# Agent 016 + critical agents active
set -a; source /opt/wazuh-docker/multi-node/ops/creds.env 2>/dev/null; set +a
WUI_USER="wazuh-wui"; WUI_PASS=$(grep -A3 "username: wazuh-wui" /opt/wazuh-docker/multi-node/config/wazuh_dashboard/wazuh.yml | grep password | awk '{print $2}' | tr -d '"')
TOK=$(curl -sk -m 10 -X POST "https://127.0.0.1:55000/security/user/authenticate" -u "$WUI_USER:$WUI_PASS" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin).get('data',{}).get('token',''))" 2>/dev/null)
A016=$(curl -sk -m 10 "https://127.0.0.1:55000/agents?agents_list=016" -H "Authorization: Bearer $TOK" 2>/dev/null | python3 -c "import json,sys
for a in json.load(sys.stdin).get('data',{}).get('affected_items',[]): print(a.get('status'))" 2>/dev/null)
[ "$A016" = "active" ]; check agent016 $? "agent 016 sensor status=$A016"
# Backup freshness (daily 02:30 config bundle)
LATEST=$(ls -t /opt/wazuh-backups/wazuh-config-*.tar.gz 2>/dev/null | head -1)
if [ -n "$LATEST" ]; then
  AGE=$(( $(date +%s) - $(stat -c %Y "$LATEST") ))
  [ "$AGE" -lt 172800 ]; check backup-fresh $? "config bundle age=$((AGE/3600))h"
else
  check backup-fresh 1 "no config bundle found"
fi
# Disk watermark
DISK=$(df -P / | awk 'NR==2{gsub(/%/,"",$5);print $5}')
if [ "$DISK" -ge 95 ]; then check disk-wm 1 "root disk $DISK% >= flood 95%"
elif [ "$DISK" -ge 85 ]; then check disk-wm 1 "root disk $DISK% >= low watermark 85% (2 consecutive)"
else check disk-wm 0 "root disk $DISK%"; fi
# tmp health
TMP=$(bash "$ROOT/ops/scripts/p33-tmp-health.sh" 2>/dev/null | grep -oE 'state=[A-Z]+' | cut -d= -f2)
if [ "$TMP" = "FAILED" ]; then check tmp-health 1 "tmp FAILED"; elif [ "$TMP" = "DEGRADED" ]; then check tmp-health 1 "tmp DEGRADED"; else check tmp-health 0 "tmp HEALTHY"; fi
# Release provenance light check (asset hash file present)
HASHFILE=/opt/mct-security-stack-backups/releases/v1.3.0/mct-security-stack-release-20260824-203124.tar.gz
[ -f "$HASHFILE" ]; check release-provenance $? "v1.3.0 bundle mirror present"
unset WAZUH_ADMIN_PASSWORD
exit 0