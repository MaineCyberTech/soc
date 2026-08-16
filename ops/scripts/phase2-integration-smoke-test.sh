#!/usr/bin/env bash
# Phase 2 integration smoke test: exercises the core routes that can be tested
# without production services. Services that are not deployed are SKIPPED.
# Usage: phase2-integration-smoke-test.sh
set -uo pipefail

MCT_ROOT="${MCT_STACK_ROOT:-/opt/mct-security-stack}"
SKIP=0; PASS=0; FAIL=0

note() { echo "[..] $*"; }
ok()   { echo "[OK]   $*"; PASS=$((PASS+1)); }
skip() { echo "[SKIP] $*"; SKIP=$((SKIP+1)); }
bad()  { echo "[FAIL] $*"; FAIL=$((FAIL+1)); }

# 1. Wazuh health (local API, no secrets printed)
if docker ps --format '{{.Names}}' | grep -q 'multi-node-wazuh.master-1'; then
  ok "wazuh.master running"
else
  bad "wazuh.master missing"
fi

# 2. Shuffle webhook (if deployed)
if docker ps --format '{{.Names}}' | grep -qi shuffle; then
  code=$(curl -sk -o /dev/null -w '%{http_code}' -m 5 http://127.0.0.1:3001/api/v1/status 2>/dev/null)
  [[ "$code" == "200" || "$code" == "404" ]] && ok "shuffle reachable (HTTP $code)" || bad "shuffle status HTTP $code"
else
  skip "shuffle not deployed"
fi

# 3. DFIR-IRIS API (if deployed)
if docker ps --format '{{.Names}}' | grep -qi dfir-iris; then
  code=$(curl -sk -o /dev/null -w '%{http_code}' -m 5 http://127.0.0.1:8000/login 2>/dev/null)
  [[ "$code" == "200" || "$code" == "302" ]] && ok "iris reachable (HTTP $code)" || bad "iris HTTP $code"
else
  skip "iris not deployed"
fi

# 4. MISP (if deployed)
if docker ps --format '{{.Names}}' | grep -qi misp; then
  code=$(curl -sk -o /dev/null -w '%{http_code}' -m 5 https://127.0.0.1:8443/users/login 2>/dev/null)
  [[ "$code" == "200" || "$code" == "301" || "$code" == "302" ]] && ok "misp reachable (HTTP $code)" || bad "misp HTTP $code"
else
  skip "misp not deployed"
fi

# 5. Velociraptor (if deployed)
if docker ps --format '{{.Names}}' | grep -qi velociraptor; then
  code=$(curl -sk -o /dev/null -w '%{http_code}' -m 5 https://127.0.0.1:8889/app/index.html 2>/dev/null)
  [[ "$code" == "200" || "$code" == "401" ]] && ok "velociraptor reachable (HTTP $code)" || bad "velociraptor HTTP $code"
else
  skip "velociraptor not deployed"
fi

# 6. OpenCanary (if deployed) — check recent log activity instead of touching a canary port
if docker ps --format '{{.Names}}' | grep -qi opencanary; then
  if docker logs --tail 20 opencanary 2>/dev/null | grep -qi 'opencanary'; then
    ok "opencanary logging"
  else
    note "opencanary running but no recent logs"
  fi
else
  skip "opencanary not deployed"
fi

# 7. Greenbone (if deployed)
if docker ps --format '{{.Names}}' | grep -qi greenbone; then
  code=$(curl -sk -o /dev/null -w '%{http_code}' -m 5 http://127.0.0.1:9392/login 2>/dev/null)
  [[ "$code" == "200" || "$code" == "302" ]] && ok "greenbone reachable (HTTP $code)" || bad "greenbone HTTP $code"
else
  skip "greenbone not deployed"
fi

# 8. Reporting generator smoke (always)
if python3 "$MCT_ROOT/ops/scripts/generate-scorecard.example.py" >/dev/null 2>&1; then
  ok "scorecard generator produced output"
else
  bad "scorecard generator failed"
fi

# 9. CDB export script syntax check (always)
if python3 -m py_compile "$MCT_ROOT/ops/scripts/misp-to-wazuh-cdb.example.py" 2>/dev/null; then
  ok "misp-to-wazuh-cdb.example.py compiles"
else
  bad "misp-to-wazuh-cdb.example.py syntax error"
fi

echo
echo "PASS=$PASS SKIP=$SKIP FAIL=$FAIL"
[[ $FAIL -eq 0 ]]
