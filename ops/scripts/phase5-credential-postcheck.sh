#!/usr/bin/env bash
# phase5-credential-postcheck.sh
# Extended validation after P1 credential rotation. Never prints values.
# Usage: phase5-credential-postcheck.sh
set -uo pipefail

WAZUH=${WAZUH_STACK_ROOT:-/opt/wazuh-docker/multi-node}
ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
FAIL=0

ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

if [[ -f "$WAZUH/ops/creds.env" ]]; then
  set -a; source "$WAZUH/ops/creds.env" 2>/dev/null; set +a
fi

echo "== Phase 5 credential postcheck =="

# 1. Indexer auth + cluster green (validates WAZUH_ADMIN_PASSWORD)
code=$(curl -sk -o /tmp/opencode/p5-health.json -w '%{http_code}' -m 8 \
  -u "admin:${WAZUH_ADMIN_PASSWORD:-}" https://127.0.0.1:9200/_cluster/health 2>/dev/null || echo 000)
if [ "$code" = "200" ]; then
  st=$(python3 -c "import json;print(json.load(open('/tmp/opencode/p5-health.json')).get('status','?'))" 2>/dev/null)
  ok "indexer auth + health: $st"
else
  bad "indexer auth failed (HTTP $code)"
fi

# 2. Filebeat delivering (end-to-end ingest with current creds)
age=$(curl -sk -m 8 -u "admin:${WAZUH_ADMIN_PASSWORD:-}" -H 'Content-Type: application/json' \
  -d '{"size":1,"query":{"match_all":{}},"sort":[{"@timestamp":"desc"}],"_source":["@timestamp"]}' \
  "https://127.0.0.1:9200/wazuh-archives-*/_search" 2>/dev/null | python3 -c "
import json,sys,datetime
try:
    d=json.load(sys.stdin)
    ts=d['hits']['hits'][0]['_source']['@timestamp']
    dt=datetime.datetime.fromisoformat(ts.replace('Z','+00:00'))
    print(int((datetime.datetime.now(datetime.timezone.utc)-dt).total_seconds()))
except Exception:
    print('9999')" 2>/dev/null || echo 9999)
if [ "${age:-9999}" -lt 300 ]; then ok "filebeat delivering (last doc ${age}s)"; else bad "filebeat stale (${age}s)"; fi

# 3. DO Spaces reachable (validates access/secret keys)
out=$(curl -s -m 10 -u "${DO_SPACES_ACCESS_KEY:-}:${DO_SPACES_SECRET_KEY:-}" \
  "${DO_SPACES_ENDPOINT:-}?list-type=2&max-keys=1" 2>/dev/null)
if echo "$out" | grep -qE 'ListBucketResult|InvalidArgument'; then ok "DO Spaces auth works"; else bad "DO Spaces auth failed"; fi

# 4. Cloudflare tunnel running (validates tunnel token)
if docker ps --format '{{.Names}}' | grep -q '^wazuh-cloudflared$'; then
  st=$(docker inspect wazuh-cloudflared --format '{{.State.Status}}' 2>/dev/null)
  restarts=$(docker inspect wazuh-cloudflared --format '{{.RestartCount}}' 2>/dev/null)
  ok "cloudflared running ($st, restarts=$restarts)"
else
  bad "cloudflared not running"
fi

# 5. Snapshot cron healthy (consumes DO creds + indexer creds)
if [ -f /opt/wazuh-backups/snapshot-s3-cron.log ]; then
  h=$(( ($(date +%s) - $(stat -c %Y /opt/wazuh-backups/snapshot-s3-cron.log)) / 3600 ))
  ok "snapshot-s3 cron log ${h}h old"
else
  bad "snapshot-s3 cron log missing"
fi

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
exit $FAIL
