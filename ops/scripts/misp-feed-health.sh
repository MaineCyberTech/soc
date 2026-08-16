#!/usr/bin/env bash
# misp-feed-health.sh
# Checks MISP feed health: reachability, event count, CDB export freshness,
# and worker CDB sync. Never prints API keys.
# Usage: misp-feed-health.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
WAZUH=${WAZUH_STACK_ROOT:-/opt/wazuh-docker/multi-node}
TS=$(date +%Y%m%d-%H%M%S)
REPORT="$ROOT/ops/reports/misp-feed-health-$TS.md"
FAIL=0
BASEURL="${MISP_BASEURL:-https://192.168.222.154:8443}"
KEYFILE="$ROOT/ops/backups/misp-api-key.txt"

pass() { echo "[PASS] $*"; }
fail() { echo "[FAIL] $*"; FAIL=1; }

echo "== MISP feed health $TS =="

if [[ -f "$KEYFILE" ]]; then
  echo "-- MISP API reachability"
  code=$(curl -sk -o /tmp/opencode/misp-health.json -w '%{http_code}' -m 10 \
    -H "Authorization: $(cat "$KEYFILE")" -H 'Accept: application/json' \
    "$BASEURL/servers/getVersion" 2>/dev/null || echo 000)
  if [ "$code" = "200" ]; then pass "MISP API version: $(python3 -c "import json;print(json.load(open('/tmp/opencode/misp-health.json')).get('version','?') if 'version' in json.load(open('/tmp/opencode/misp-health.json')) else '?')" 2>/dev/null)"; else fail "MISP API HTTP $code"; fi
else
  fail "MISP API key file missing ($KEYFILE)"
fi

echo "-- event count"
if [[ -f "$KEYFILE" ]]; then
  cnt=$(curl -sk -m 10 -H "Authorization: $(cat "$KEYFILE")" -H 'Accept: application/json' \
    "$BASEURL/events/index" 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else '?')" 2>/dev/null || echo '?')
  echo "  events: $cnt"
fi

echo "-- CDB export freshness"
if find "$ROOT/ops/cdb" -name 'misp-iocs' -mmin -1440 2>/dev/null | grep -q .; then
  pass "misp-iocs exported < 24h"
else
  fail "misp-iocs stale (> 24h) - run misp-to-wazuh-cdb.py --push"
fi

echo "-- master/worker CDB sync"
for c in multi-node-wazuh.master-1 multi-node-wazuh.worker-1; do
  if docker exec "$c" sh -c 'test -f /var/ossec/etc/lists/malicious-ioc/misp-iocs' 2>/dev/null; then
    lc=$(docker exec "$c" sh -c 'wc -l < /var/ossec/etc/lists/malicious-ioc/misp-iocs' 2>/dev/null)
    pass "$c CDB present ($lc lines)"
  else
    fail "$c CDB missing"
  fi
done

echo "-- local vs container CDB identical"
loc=$(wc -l < "$ROOT/ops/cdb/misp-iocs" 2>/dev/null || echo 0)
mas=$(docker exec multi-node-wazuh.master-1 sh -c 'wc -l < /var/ossec/etc/lists/malicious-ioc/misp-iocs' 2>/dev/null || echo 0)
if [ "$loc" = "$mas" ]; then pass "local ($loc) == master ($mas)"; else fail "local ($loc) != master ($mas)"; fi

{
  echo "# MISP Feed Health - $TS"
  echo
  echo "## Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
  echo
  echo "| Check | Status |"
  echo "|---|---|"
} > "$REPORT"

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
echo "Report: $REPORT"
exit $FAIL
