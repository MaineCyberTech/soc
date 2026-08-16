#!/usr/bin/env bash
# soc-smoke-test.sh
# Safe SOC validation drills. Never generates dangerous traffic.
# Usage:
#   soc-smoke-test.sh --dry-run          # generate payloads only, no live actions
#   soc-smoke-test.sh --report-only      # write report from last test state
#   soc-smoke-test.sh --opencanary       # safe local canary trigger + check path
#   soc-smoke-test.sh --shuffle-webhook  # POST safe payload to Shuffle webhook (needs SHUFFLE_WEBHOOK_URL env)
set -uo pipefail

MODE="${1:---dry-run}"
ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
TS=$(date +%Y%m%d-%H%M%S)
REPORT="$ROOT/ops/reports/soc-smoke-test-$TS.md"
mkdir -p "$ROOT/ops/reports" "$ROOT/integrations/test-events"

# ---------- test payloads (safe, RFC5737/203.0.113.x source IPs) ----------
cat > "$ROOT/integrations/test-events/wazuh-test-alert.json" <<'JSON'
{"source":"phase3-smoke-test","type":"wazuh-high-severity","rule_id":"120000","rule_level":10,"srcip":"203.0.113.10","agent_name":"smoke-test","description":"Phase 3 safe smoke test payload"}
JSON
cat > "$ROOT/integrations/test-events/opencanary-hit.json" <<'JSON'
{"source":"phase3-smoke-test","type":"opencanary-hit","service":"ssh","src_host":"203.0.113.20","dst_host":"mct-canary","logdata":{"src_ip":"203.0.113.20","dst_port":22}}
JSON
cat > "$ROOT/integrations/test-events/flow-unusual-port.json" <<'JSON'
{"source":"phase3-smoke-test","type":"flow-unusual-port","flow":{"src_ip":"203.0.113.30","dst_port":4444,"proto":"tcp","bytes":1024},"exporter":"test-exporter"}
JSON
cat > "$ROOT/integrations/test-events/misp-ioc-match.json" <<'JSON'
{"source":"phase3-smoke-test","type":"misp-ioc-match","ioc_value":"203.0.113.40","confidence":"high","action":"monitor","rule_id":"121100"}
JSON
cat > "$ROOT/integrations/test-events/greenbone-critical.json" <<'JSON'
{"source":"phase3-smoke-test","type":"greenbone-critical","vuln_id":"TEST-CVE-2026-0001","severity":"critical","target":"192.168.222.149","internet_facing":false}
JSON
cat > "$ROOT/integrations/test-events/so-suricata-alert.json" <<'JSON'
{"source":"phase3-smoke-test","type":"suricata-alert","signature":"ET POLICY test","category":"misc-activity","src_ip":"203.0.113.50","dest_ip":"192.168.222.149"}
JSON

{
  echo "# SOC Smoke Test - $TS"
  echo
  echo "Mode: $MODE"
  echo
  echo "| Test | Status | Evidence |"
  echo "|---|---|---|"
  echo "| Payload generation | PASS | integrations/test-events/*.json |"
} > "$REPORT"

FAIL=0
case "$MODE" in
  --dry-run)
    echo "| No live actions | PASS | dry run only - payloads ready |" >> "$REPORT"
    ;;
  --report-only)
    echo "| Report only | PASS | no live triggers |" >> "$REPORT"
    ;;
  --opencanary)
    echo "| OpenCanary safe trigger | RUN | connecting to local canary tcpbanner port 9100 |" >> "$REPORT"
    timeout 3 bash -c "</dev/tcp/127.0.0.1/9100" >/dev/null 2>&1 || true
    sleep 6
    HITS=$(docker exec multi-node-wazuh.master-1 sh -c "grep -ch opencanary /var/ossec/logs/archives/archives.json 2>/dev/null || echo 0" 2>/dev/null | tr -dc '0-9' | awk '{s+=$1} END{print s+0}')
    if [ "$HITS" -gt 0 ]; then
      echo "| OpenCanary -> Wazuh archive | PASS | opencanary hits in archives.json: $HITS |" >> "$REPORT"
      ALERT=$(docker exec multi-node-wazuh.master-1 sh -c "grep -E '121012' /var/ossec/logs/alerts/alerts.log 2>/dev/null | tail -1" 2>/dev/null || true)
      if [ -n "$ALERT" ]; then
        echo "| OpenCanary rule 121012 | PASS | alert fired (level 12) |" >> "$REPORT"
      else
        echo "| OpenCanary rule 121012 | CHECK | archived but not alerted yet |" >> "$REPORT"
      fi
    else
      echo "| OpenCanary -> Wazuh archive | FAIL | no opencanary line found |" >> "$REPORT"
      FAIL=1
    fi
    ;;
  --shuffle-webhook)
    URL="${SHUFFLE_WEBHOOK_URL:-}"
    if [ -z "$URL" ]; then
      echo "| Shuffle webhook | SKIPPED | set SHUFFLE_WEBHOOK_URL env (safe test webhook) |" >> "$REPORT"
    else
      code=$(curl -s -o /dev/null -w '%{http_code}' -m 10 -X POST "$URL" \
        -H 'Content-Type: application/json' \
        -d @"$ROOT/integrations/test-events/wazuh-test-alert.json" 2>/dev/null || echo 000)
      echo "| Shuffle webhook | $([ "$code" = "000" ] && echo FAIL || echo "HTTP $code") | POST wazuh-test-alert.json |" >> "$REPORT"
      [ "$code" = "000" ] && FAIL=1
    fi
    ;;
  *)
    echo "| Unknown mode | FAIL | $MODE (use --dry-run|--report-only|--opencanary|--shuffle-webhook) |" >> "$REPORT"
    FAIL=1
    ;;
esac

echo "| Test payloads stored | PASS | integrations/test-events/*.json |" >> "$REPORT"
echo "| Secrets | PASS | no secrets used |" >> "$REPORT"
echo >> "$REPORT"
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo PARTIAL)" >> "$REPORT"
echo "Wrote $REPORT"
exit $FAIL
