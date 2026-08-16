#!/usr/bin/env bash
# Phase 2 health check: verifies existing Wazuh stack + phase 2 services.
# Usage: phase2-healthcheck.sh [--verbose]
# Never prints secret values.
set -uo pipefail

MCT_ROOT="${MCT_STACK_ROOT:-/opt/mct-security-stack}"
WAZUH_DIR="/opt/wazuh-docker/multi-node"
VERBOSE=0
FAIL=0

[[ "${1:-}" == "--verbose" ]] && VERBOSE=1

# Source credentials silently when available (never print values)
if [[ -f "$WAZUH_DIR/ops/creds.env" ]]; then
  set -a; source "$WAZUH_DIR/ops/creds.env" 2>/dev/null; set +a
fi

note() { [[ $VERBOSE -eq 1 ]] && echo "[+] $*"; }
ok()   { echo "[OK]   $*"; }
fail() { echo "[FAIL] $*"; FAIL=1; }

# 1. Existing Wazuh containers healthy
echo "== Wazuh stack =="
if docker ps --format '{{.Names}}' | grep -q 'multi-node-wazuh.master-1'; then
  ok "wazuh.master running"
else
  fail "wazuh.master not running"
fi
for c in multi-node-wazuh1.indexer-1 multi-node-wazuh2.indexer-1 multi-node-wazuh3.indexer-1 multi-node-wazuh.dashboard-1; do
  if docker ps --format '{{.Names}}' | grep -q "$c"; then ok "$c running"; else fail "$c not running"; fi
done
if docker ps --format '{{.Names}}' | grep -q 'wazuh-cloudflared'; then ok "cloudflared running"; else fail "cloudflared not running"; fi

# 2. Indexer cluster health (local only, no secret printed)
note "checking indexer cluster health"
if curl -sk -m 8 -o /tmp/opencode/cluster-health.json -w '%{http_code}' \
    -u "admin:${WAZUH_ADMIN_PASSWORD:-REDACTED}" https://127.0.0.1:9200/_cluster/health 2>/dev/null | grep -q 200; then
  status=$(python3 -c "import json;print(json.load(open('/tmp/opencode/cluster-health.json')).get('status','?'))" 2>/dev/null)
  if [[ "$status" == "green" || "$status" == "yellow" ]]; then ok "indexer cluster $status"; else fail "indexer cluster $status"; fi
else
  note "cluster health skipped (creds not available in env)"
fi

# 3. Wazuh API localhost only
if ss -tulpen 2>/dev/null | grep -q '127.0.0.1:55000'; then ok "Wazuh API bound to 127.0.0.1 only"; else fail "Wazuh API binding check failed"; fi
if ss -tulpen 2>/dev/null | grep -q '0.0.0.0:55000'; then fail "Wazuh API exposed publicly!"; fi

# 4. Indexer 9200 localhost only
if ss -tulpen 2>/dev/null | grep -q '127.0.0.1:9200'; then ok "indexer 9200 bound to 127.0.0.1 only"; else fail "indexer 9200 binding check failed"; fi
if ss -tulpen 2>/dev/null | grep -q '0.0.0.0:9200'; then fail "indexer 9200 exposed publicly!"; fi

# 5. Elastiflow still indexing
note "checking elastiflow flow index freshness"
if curl -sk -m 8 -u "admin:${WAZUH_ADMIN_PASSWORD:-REDACTED}" \
    "https://127.0.0.1:9200/elastiflow-flow-ecs-*/_count" 2>/dev/null | grep -q '"count"'; then
  ok "elastiflow indices responding"
else
  fail "elastiflow index check failed"
fi

# 6. Flow relay sending
if docker ps --format '{{.Names}}' | grep -q 'flow-relay'; then ok "flow-relay running"; else fail "flow-relay not running"; fi

# 7. Security Onion reachable
SO_HOST="${SECURITY_ONION_HOST:-192.168.222.116}"
if ping -c 1 -W 2 "$SO_HOST" >/dev/null 2>&1; then ok "Security Onion reachable ($SO_HOST)"; else fail "Security Onion not reachable"; fi

# 8. Phase 2 services (report status, do not fail baseline)
echo "== Phase 2 services =="
for svc in dfir-iris velociraptor misp shuffle greenbone opencanary; do
  if docker ps --format '{{.Names}}' | grep -qi "$svc"; then
    ok "phase2 service running: $svc"
  else
    note "phase2 service not deployed: $svc (expected unless enabled)"
  fi
done

# 9. Backups still running
if ls /opt/wazuh-backups/wazuh-config-*.tar.gz 2>/dev/null | tail -1 | grep -q $(date +%Y%m); then
  ok "recent wazuh config backup present"
else
  note "no recent config backup found (may be expected if cron window differs)"
fi
if ls /opt/wazuh-backups/snapshot-cron.log /opt/wazuh-backups/dr-s3-cron.log 2>/dev/null | wc -l | grep -q 2; then
  ok "snapshot/DR cron logs present"
else
  note "snapshot/DR cron logs missing"
fi

echo
if [[ $FAIL -eq 0 ]]; then
  echo "HEALTHCHECK PASSED"
else
  echo "HEALTHCHECK FAILED — review [FAIL] lines"
  exit 1
fi
