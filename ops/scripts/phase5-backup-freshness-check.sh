#!/usr/bin/env bash
# phase5-backup-freshness-check.sh
# Freshness check for all phase 5 backup streams with pass/fail.
# Usage: phase5-backup-freshness-check.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
FAIL=0
now() { date +%s; }

ok() { echo "[OK]   $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

check_newest() {
  local label=$1 dir=$2 maxh=$3 pattern="${4:-*}"
  local newest
  newest=$(find "$dir" -maxdepth 1 -type f -name "$pattern" -mmin "-$((maxh*60))" 2>/dev/null | head -1)
  if [ -n "$newest" ]; then ok "$label (newest < ${maxh}h): $(basename "$newest")"; else bad "$label (nothing < ${maxh}h)"; fi
}

echo "== Phase 5 backup freshness =="
check_newest "IRIS DB dump"       "$ROOT/ops/backups"          26 "iris-db-*.sql.gz"
check_newest "MISP DB dump"       "$ROOT/ops/backups/vm103"    26 "misp-db-*.sql.gz"
check_newest "Greenbone dump"     "$ROOT/ops/backups/vm103"    170 "greenbone-gvmd-*.sql.gz"
check_newest "Shuffle export"     "$ROOT/ops/backups/shuffle-workflows" 170 "shuffle-workflows-*.json"
check_newest "OpenSearch local"   /opt/wazuh-backups/elasticsearch 6 "snap-*.dat"

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
exit $FAIL
