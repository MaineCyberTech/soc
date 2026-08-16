#!/usr/bin/env bash
# check-prereqs.sh - verify required tooling for operating the stack.
# Usage: bash scripts/bootstrap/check-prereqs.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
FAIL=0
ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

echo "== Prereq check $(date -u '+%Y-%m-%d %H:%M') =="

for cmd in docker curl python3 sshpass jq gzip tar git; do
  command -v "$cmd" >/dev/null 2>&1 && ok "$cmd" || bad "$cmd missing"
done

[ -d "$ROOT" ] && ok "stack root $ROOT" || bad "stack root missing"
[ -d /opt/wazuh-docker/multi-node ] && ok "wazuh root" || bad "wazuh root missing"
[ -f /opt/wazuh-docker/multi-node/ops/creds.env ] && ok "creds.env present" || bad "creds.env missing"
docker ps >/dev/null 2>&1 && ok "docker daemon reachable" || bad "docker daemon not reachable"

echo "== Result: $([ $FAIL -eq 0 ] && echo PASS || echo ACTION REQUIRED) =="
exit $FAIL
