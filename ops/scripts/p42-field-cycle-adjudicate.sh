#!/usr/bin/env bash
# P42 five-condition band adjudication for wazuh-archives-4.x-2026.08.27
# Conditions (precommitted phase41-13/phase42-03):
#  C1 limit=2000 effective   C2 ISM archives-14d assigned
#  C3 zero full-stats docs   C4 rejection flatline holds  C5 leaf count <=1400
IDX=${1:-wazuh-archives-4.x-2026.08.27}
OS="curl -sk -u admin:[REDACTED-PW] https://127.0.0.1:9200"
echo "== Field cycle adjudication: $IDX =="
C1=$($OS "$IDX/_settings" | python3 -c "import json,sys;d=json.load(sys.stdin);print(list(d.values())[0]['settings']['index'].get('mapping',{}).get('total_fields',{}).get('limit','MISSING'))")
echo "C1 limit=$C1 $([ "$C1" = "2000" ] && echo PASS || echo FAIL)"
C2=$($OS "$IDX/_settings" | python3 -c "import json,sys;d=json.load(sys.stdin);print(list(d.values())[0]['settings']['index'].get('plugins',{}).get('index_state_management',{}).get('policy_id','MISSING'))")
echo "C2 ism=$C2 $([ "$C2" = "wazuh-archives-14d" ] && echo PASS || echo FAIL)"
C3=$(docker logs multi-node-wazuh.master-1 --since 24h 2>&1 | awk '/2026-08-2[67]/' | grep -c "stats_compact" )
FULLSTATS=$($OS "$IDX/_count?q=data.event_type:%22stats%22" 2>/dev/null | python3 -c "import json,sys;print(json.load(sys.stdin)['count'])" 2>/dev/null)
echo "C3 full-stats docs in $IDX: ${FULLSTATS:-ERR} $([ "${FULLSTATS:-1}" = "0" ] && echo PASS || echo FAIL)"
REJ=$(docker logs multi-node-wazuh.master-1 --since "${2:-12h}" 2>&1 | grep -c "Limit of total fields")
echo "C4 rejections last ${2:-12h}: $REJ $([ "$REJ" = "0" ] && echo PASS || echo FAIL)"
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh "$IDX" 2>/dev/null | head -1
