#!/usr/bin/env bash
# verify-portable-repo.sh - verify the repo is in portable, clean state.
# Usage: bash scripts/verify/verify-portable-repo.sh
set -uo pipefail
source /opt/wazuh-docker/multi-node/ops/creds.env 2>/dev/null

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
FAIL=0
ok() { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

echo "== Portable repo verify $(date -u '+%Y-%m-%d %H:%M') =="

# 1. required files present
for f in README.md REPO-MAP.md ARCHITECTURE.md PORTABILITY.md SECURITY.md .env.example; do
  [ -f "$ROOT/$f" ] && ok "$f" || bad "$f MISSING"
done

# 2. flag env files with loose permissions (0600 expected); live .env files are
#    correct on the server but MUST be excluded from any portable bundle.
SEC=$(find "$ROOT" -type f ! -path "*/evidence/*" ! -path "*/data/*" \( -name "*.env" -o -name "creds.env" -o -name ".env.cloudflare" \) ! -name "*.example*" -printf "%m %p\n" 2>/dev/null | awk '$1 != "600" {print}')
if [ -z "$SEC" ]; then ok "env files 0600 (or absent)"; else bad "loose-permission env files:\n$SEC"; fi

# 3. evidence index exists
[ -f "$ROOT/evidence/HISTORICAL-REPORTS-README.md" ] && ok "evidence index" || bad "evidence index missing"

# 4. bootstrap + verify scripts present
for s in check-prereqs create-directories render-env-summary verify-stack-layout \
  verify-current-architecture verify-no-stale-phase-refs verify-portable-repo; do
  find "$ROOT/scripts" -name "$s.sh" | grep -q . && ok "$s.sh" || bad "$s.sh MISSING"
done

echo "== Result: $([ $FAIL -eq 0 ] && echo PASS || echo ACTION REQUIRED) =="
exit $FAIL
