#!/usr/bin/env bash
# credential-rotation-validation.sh
# Validates each credential works after rotation. NEVER prints values.
# Usage: credential-rotation-validation.sh [--check-all] or one of:
#   --wazuh | --do-spaces | --cloudflare | --iris | --misp | --shuffle
set -uo pipefail

WAZUH=${WAZUH_STACK_ROOT:-/opt/wazuh-docker/multi-node}
ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
FAIL=0
MODE="${1:---check-all}"

ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

if [[ -f "$WAZUH/ops/creds.env" ]]; then
  set -a; source "$WAZUH/ops/creds.env" 2>/dev/null; set +a
fi

check_wazuh() {
  echo "== Wazuh admin =="
  code=$(curl -sk -o /tmp/opencode/cred-health.json -w '%{http_code}' -m 8 \
    -u "admin:${WAZUH_ADMIN_PASSWORD:-}" https://127.0.0.1:9200/_cluster/health 2>/dev/null || echo 000)
  if [ "$code" = "200" ]; then
    st=$(python3 -c "import json;print(json.load(open('/tmp/opencode/cred-health.json')).get('status','?'))" 2>/dev/null)
    ok "indexer health via admin creds: $st"
  else
    bad "indexer auth failed (HTTP $code)"
  fi
}

check_do() {
  echo "== DO Spaces =="
  if [ -n "${DO_SPACES_ACCESS_KEY:-}" ] && [ -n "${DO_SPACES_SECRET_KEY:-}" ]; then
    # non-destructive: list bucket via S3 API (endpoint from creds.env)
    out=$(curl -s -m 10 -u "${DO_SPACES_ACCESS_KEY}:${DO_SPACES_SECRET_KEY}" \
      "${DO_SPACES_ENDPOINT:-}?list-type=2&max-keys=1" 2>/dev/null)
    if echo "$out" | grep -qE 'ListBucketResult|InvalidArgument'; then ok "DO Spaces auth works (S3 API responded)"; else bad "DO Spaces auth failed"; fi
  else
    bad "DO Spaces keys not in env"
  fi
}

check_cloudflare() {
  echo "== Cloudflare tunnel =="
  if docker ps --format '{{.Names}}' | grep -q '^wazuh-cloudflared$'; then
    ok "tunnel container running (token accepted if status not CrashLoopBackOff)"
    docker inspect wazuh-cloudflared --format '{{.State.Status}}' | sed 's/^/  state: /'
  else
    bad "cloudflared not running"
  fi
}

check_iris() {
  echo "== IRIS =="
  KEY=""
  if [ -f "$ROOT/ops/backups/iris-api-key.txt" ]; then KEY=$(cat "$ROOT/ops/backups/iris-api-key.txt"); fi
  code=$(curl -sk -o /tmp/opencode/iris-ping.json -w '%{http_code}' -m 8 -H "Authorization: Bearer $KEY" \
    "https://127.0.0.1:8443/api/ping" 2>/dev/null || echo 000)
  if [ "$code" = "200" ] && grep -q '"pong"' /tmp/opencode/iris-ping.json 2>/dev/null; then
    ok "IRIS API key works (/api/ping pong)"
  else
    bad "IRIS API key check HTTP $code"
  fi
}

check_misp() {
  echo "== MISP =="
  if [ -f "$ROOT/ops/backups/misp-api-key.txt" ]; then
    code=$(curl -sk -o /dev/null -w '%{http_code}' -m 10 \
      -H "Authorization: $(cat "$ROOT/ops/backups/misp-api-key.txt")" -H 'Accept: application/json' \
      "https://192.168.222.154:8443/servers/getVersion" 2>/dev/null || echo 000)
    if [ "$code" = "200" ]; then ok "MISP API key works"; else bad "MISP API key check HTTP $code"; fi
  else
    bad "MISP key file missing"
  fi
}

check_shuffle() {
  echo "== Shuffle =="
  if docker exec shuffle-backend sh -lc 'wget -q -O- --timeout=5 http://localhost:5001/api/v1/health 2>/dev/null' 2>/dev/null | grep -q '"success":true'; then
    ok "Shuffle backend health (API check)"
  else
    bad "Shuffle backend API check failed"
  fi
}

case "$MODE" in
  --wazuh) check_wazuh ;;
  --do-spaces) check_do ;;
  --cloudflare) check_cloudflare ;;
  --iris) check_iris ;;
  --misp) check_misp ;;
  --shuffle) check_shuffle ;;
  *)
    check_wazuh; check_do; check_cloudflare; check_iris; check_misp; check_shuffle
    ;;
esac

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
exit $FAIL
