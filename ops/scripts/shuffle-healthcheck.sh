#!/usr/bin/env bash
# shuffle-healthcheck.sh
# Verifies Shuffle frontend/backend/worker health, network membership, and
# webhook reachability. Writes report to ops/reports. Never prints secrets.
# Usage: shuffle-healthcheck.sh [--webhook URL]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
NETWORK=${NETWORK:-mct-security}
WEBHOOK="${1:-}"
TS=$(date +%Y%m%d-%H%M%S)
REPORT="$ROOT/ops/reports/shuffle-healthcheck-$TS.md"
FAIL=0

pass() { echo "[PASS] $*"; }
fail() { echo "[FAIL] $*"; FAIL=1; }

echo "== Shuffle healthcheck $TS =="

echo "-- containers"
for c in shuffle-frontend shuffle-backend shuffle-opensearch shuffle-orborus shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu; do
  if docker ps --format '{{.Names}}' | grep -qx "$c"; then pass "container $c running"; else fail "container $c NOT running"; fi
done

echo "-- frontend HTTP"
code=$(curl -s -o /dev/null -w '%{http_code}' -m 8 http://127.0.0.1:3001/ 2>/dev/null || echo 000)
if [[ "$code" =~ ^(200|301|302|401|302)$ ]]; then pass "frontend HTTP $code"; else fail "frontend HTTP $code"; fi

echo "-- backend reachable"
if docker exec shuffle-backend sh -lc 'wget -q -O- --timeout=5 http://localhost:5001/api/v1/health 2>/dev/null' 2>/dev/null | grep -q '"success":true'; then
  pass "backend API responding (health ok)"
else
  fail "backend API not responding"
fi

echo "-- network membership on $NETWORK"
missing=0
for c in $(docker ps --format '{{.Names}}' | grep -Ei 'shuffle|worker|frontend|backend' || true); do
  if docker inspect "$c" --format '{{json .NetworkSettings.Networks}}' 2>/dev/null | grep -q "\"$NETWORK\""; then
    :
  else
    echo "  [MISS] $c not on $NETWORK"
    missing=$((missing+1))
  fi
done
if [ $missing -eq 0 ]; then pass "all shuffle containers on $NETWORK"; else fail "$missing container(s) off $NETWORK (run shuffle-repair-network.sh --apply)"; fi

echo "-- DNS worker -> shuffle-backend"
if docker exec shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu sh -lc 'getent hosts shuffle-backend' 2>/dev/null | grep -q .; then pass "DNS shuffle-backend resolves"; else fail "DNS shuffle-backend unresolved"; fi

echo "-- webhook probe"
if [ -n "$WEBHOOK" ]; then
  resp=$(curl -s -o /dev/null -w '%{http_code}' -m 8 -X POST "$WEBHOOK" \
    -H 'Content-Type: application/json' \
    -d '{"test":"dry-run","source":"shuffle-healthcheck"}' 2>/dev/null || echo 000)
  echo "  webhook HTTP $resp (expect 200/201/202; 4xx may be normal for bad payloads)"
else
  echo "  skipped (pass --webhook URL to probe)"
fi

{
  echo "# Shuffle Healthcheck - $TS"
  echo
  echo "## Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
  echo
  echo "## Containers"
  docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -Ei 'shuffle|worker|frontend|backend' || true
  echo
  echo "## Network membership ($NETWORK)"
  for c in $(docker ps --format '{{.Names}}' | grep -Ei 'shuffle|worker|frontend|backend' || true); do
    echo "- $c: $(docker inspect "$c" --format '{{range $k,$v := .NetworkSettings.Networks}}{{$k}} {{end}}' 2>/dev/null)"
  done
  echo
  echo "## Frontend probe: HTTP $code"
  echo "## DNS worker->backend: $(docker exec shuffle-workers.1.odzpa0kgsgcfbddij7qnywisu sh -lc 'getent hosts shuffle-backend' 2>/dev/null | head -1 || echo unresolved)"
} > "$REPORT"
ln -sf "$REPORT" "$ROOT/ops/reports/shuffle-healthcheck-latest.md"

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
echo "Report: $REPORT"
exit $FAIL
