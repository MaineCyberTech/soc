#!/usr/bin/env bash
# simulate-levelio-linux.sh - simulate Level.io variable injection on Linux/macOS.
# Tests: env success path, CLI arg success path, missing-required failure path,
# unresolved-placeholder failure path - all in dry-run mode (no changes).
# Usage: bash scripts/endpoint-deploy/test/simulate-levelio-linux.sh
set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT=$(cd "$SCRIPT_DIR/../../.." && pwd)
INSTALL="$ROOT/scripts/endpoint-deploy/install-wazuh-linux.sh"
PASS=0; FAIL=0

ok() { echo "[PASS] $*"; PASS=$((PASS+1)); }
bad() { echo "[FAIL] $*"; FAIL=$((FAIL+1)); }

echo "== Level.io variable simulation (Linux) $(date -u +%FT%TZ) =="
echo "(dry-run only - no system changes; values redacted)"

[ -x "$INSTALL" ] || { echo "install-wazuh-linux.sh missing or not executable"; exit 1; }

# 1. env-var success path (dry-run)
echo
echo "--- Test 1: env-var success path (dry-run) ---"
OUT=$(WAZUH_MANAGER=192.168.222.149 WAZUH_REG_PASSWORD=testpw WAZUH_AGENT_GROUP=linux-clients \
  bash "$INSTALL" --dry-run 2>&1)
RC=$?
if [ $RC -eq 0 ] && echo "$OUT" | grep -q "WAZUH_MANAGER=192.168.222.149" \
  && echo "$OUT" | grep -q "WAZUH_REG_PASSWORD=<set:redacted>"; then
  ok "env vars consumed; password redacted; dry-run exit 0"
else
  bad "env path failed (rc=$RC): $(echo "$OUT" | head -2)"
fi

# 2. CLI-arg success path (dry-run) - flags win over env
echo
echo "--- Test 2: CLI-arg success path (dry-run) ---"
OUT=$(WAZUH_MANAGER=wrong.example.com bash "$INSTALL" \
  --manager 192.168.222.149 --reg-password testpw --group linux-clients --dry-run 2>&1)
RC=$?
if [ $RC -eq 0 ] && echo "$OUT" | grep -q "WAZUH_MANAGER=192.168.222.149"; then
  ok "CLI flags consumed and override env"
else
  bad "CLI path failed (rc=$RC): $(echo "$OUT" | head -2)"
fi

# 3. missing required (no password) -> fail-fast exit 2
echo
echo "--- Test 3: missing required variable -> fail-fast ---"
OUT=$(bash "$INSTALL" --dry-run 2>&1); RC=$?
if [ $RC -eq 2 ] && echo "$OUT" | grep -q "WAZUH_REG_PASSWORD is required"; then
  ok "missing required -> exit 2 with clear message"
else
  bad "missing-required path failed (rc=$RC): $(echo "$OUT" | head -2)"
fi

# 4. unresolved placeholder -> treated as missing -> exit 2
echo
echo "--- Test 4: unresolved {{placeholder}} -> fail-fast ---"
OUT=$(WAZUH_REG_PASSWORD="{{WAZUH_REG_PASSWORD}}" bash "$INSTALL" --dry-run 2>&1); RC=$?
if [ $RC -eq 2 ] && echo "$OUT" | grep -q "is required"; then
  ok "unresolved placeholder -> exit 2 (not silently used as value)"
else
  bad "placeholder path failed (rc=$RC): $(echo "$OUT" | head -2)"
fi

echo
echo "== Result: PASS=$PASS FAIL=$FAIL =="
[ $FAIL -eq 0 ] || exit 1
exit 0
