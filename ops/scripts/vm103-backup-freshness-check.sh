#!/usr/bin/env bash
# vm103-backup-freshness-check.sh
# Checks freshness of VM103 (MISP/Greenbone) backups pulled to the Wazuh host.
# Usage: vm103-backup-freshness-check.sh [max hours default 48]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
MAXH="${1:-48}"
FAIL=0
DEST="$ROOT/ops/backups/vm103"

echo "== VM103 backup freshness (warn > ${MAXH}h) =="

check() {
  local label=$1 pat=$2
  local newest
  newest=$(ls -t "$DEST"/$pat 2>/dev/null | head -1)
  if [ -n "$newest" ]; then
    local age=$(( ($(date +%s) - $(stat -c %Y "$newest")) / 3600 ))
    if [ "$age" -le "$MAXH" ]; then
      echo "[OK]   $label (${age}h old): $(basename "$newest")"
    else
      echo "[FAIL] $label (${age}h old > ${MAXH}h)"
      FAIL=1
    fi
  else
    echo "[FAIL] $label: no backups found under $DEST"
    FAIL=1
  fi
}

check "MISP DB dump" "misp-db-*.sql.gz"
check "Greenbone gvmd dump" "greenbone-gvmd-*.sql.gz"

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
exit $FAIL
