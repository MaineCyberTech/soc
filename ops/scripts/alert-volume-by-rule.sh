#!/usr/bin/env bash
# alert-volume-by-rule.sh
# Queries the Wazuh alerts index for volume by rule id/level/group/agent/location.
# Uses protected creds from creds.env without printing them.
# Usage: alert-volume-by-rule.sh [HOURS]  (default 24)
set -uo pipefail

HOURS="${1:-24}"
ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
WAZUH=${WAZUH_STACK_ROOT:-/opt/wazuh-docker/multi-node}
TS=$(date +%Y%m%d-%H%M%S)
OUT="$ROOT/ops/reports/alert-volume-by-rule-$TS.md"
mkdir -p "$ROOT/ops/reports"

if [[ -f "$WAZUH/ops/creds.env" ]]; then
  set -a; source "$WAZUH/ops/creds.env" 2>/dev/null; set +a
fi

QUERY=$(cat <<EOF
{
  "size": 0,
  "query": {
    "range": { "timestamp": { "gte": "now-${HOURS}h" } }
  },
  "aggs": {
    "by_rule": {
      "terms": { "field": "rule.id", "size": 40 },
      "aggs": {
        "levels": { "terms": { "field": "rule.level", "size": 5 } },
        "groups": { "terms": { "field": "rule.groups", "size": 5 } },
        "agents": { "terms": { "field": "agent.name", "size": 5 } },
        "locations": { "terms": { "field": "location", "size": 5 } }
      }
    }
  }
}
EOF
)

resp=$(curl -sk -m 30 -u "admin:${WAZUH_ADMIN_PASSWORD:-}" \
  -H 'Content-Type: application/json' \
  -d "$QUERY" \
  "https://127.0.0.1:9200/wazuh-alerts-*/_search" 2>/dev/null) || resp=""
QUERY_FAILED=0
[ -n "$resp" ] || QUERY_FAILED=1

{
  echo "# Alert Volume by Rule - last ${HOURS}h - $TS"
  echo
  echo "| rule.id | count | top level | top group | top agent | top location |"
  echo "|---|---|---|---|---|---|"
  echo "$resp" | python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    b=d['aggregations']['by_rule']['buckets']
    for bkt in b:
        rule=bkt['key']; cnt=bkt['doc_count']
        lv=bkt['levels']['buckets'][0]['key'] if bkt['levels']['buckets'] else '?'
        gr=bkt['groups']['buckets'][0]['key'] if bkt['groups']['buckets'] else '?'
        ag=bkt['agents']['buckets'][0]['key'] if bkt['agents']['buckets'] else '?'
        lo=bkt['locations']['buckets'][0]['key'] if bkt['locations']['buckets'] else '?'
        print(f'| {rule} | {cnt} | {lv} | {gr} | {ag} | {lo} |')
except Exception as e:
    print('| query failed | | | | | |')
    print(f'<!-- {e} -->')
" 
} > "$OUT"
echo "Wrote $OUT"
# Phase 24: exit nonzero when the query failed (automation-detectable)
if [ "${QUERY_FAILED:-0}" -eq 1 ]; then
  echo "ALERT-VOLUME QUERY FAILED - report written with error row (see $OUT)"
  exit 1
fi
exit 0
