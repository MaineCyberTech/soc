#!/usr/bin/env bash
# Weekly active-response audit: counts Wazuh active-response events from the
# last 7 days and writes a summary report. Runs from cron as root (sources
# creds silently). Never prints secret values.
set -uo pipefail

MCT_ROOT="${MCT_STACK_ROOT:-/opt/mct-security-stack}"
WAZUH_DIR="/opt/wazuh-docker/multi-node"
OUT="$MCT_ROOT/reporting/output/active-response-weekly.md"

if [[ -f "$WAZUH_DIR/ops/creds.env" ]]; then
  set -a; source "$WAZUH_DIR/ops/creds.env" 2>/dev/null; set +a
fi

QUERY='{"size":0,"query":{"bool":{"filter":[{"terms":{"rule.groups":["active_response","active-response"]}},{"range":{"timestamp":{"gte":"now-7d/d"}}}]}},"aggs":{"by_rule":{"terms":{"field":"rule.id.keyword","size":20}},"by_agent":{"terms":{"field":"agent.name.keyword","size":20}}}}'

mkdir -p "$(dirname "$OUT")"
RESP=$(curl -sk -m 30 -u "admin:${WAZUH_ADMIN_PASSWORD:-REDACTED}" \
  -H 'Content-Type: application/json' \
  -X POST "https://127.0.0.1:9200/wazuh-alerts-4.x-*/_search" \
  -d "$QUERY" 2>/dev/null)

{
  echo "# Active Response Audit (weekly)"
  echo
  echo "- Generated: $(date -u +%Y-%m-%dT%H:%MZ)"
  echo "- Window: last 7 days"
  echo
  echo "## Total events"
  echo
  echo '```'
  echo "$RESP" | python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    print('total:', d.get('hits',{}).get('total',{}).get('value',0))
    aggs=d.get('aggregations',{})
    print()
    print('top rules:')
    for b in aggs.get('by_rule',{}).get('buckets',[]):
        print(f\"  {b['key']}: {b['doc_count']}\")
    print()
    print('top agents:')
    for b in aggs.get('by_agent',{}).get('buckets',[]):
        print(f\"  {b['key']}: {b['doc_count']}\")
except Exception as e:
    print('query failed:', e)
"
  echo '```'
} > "$OUT"
echo "wrote $OUT"
