#!/usr/bin/env bash
# backup-freshness-check.sh
# Reports freshness of every backup stream. Exit 1 if anything critical is stale.
# Usage: backup-freshness-check.sh [--warn-hours 24]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
WARN_H=${1:-24}
FAIL=0

now() { date +%s; }
age() { echo $(( ($(now) - $(stat -c %Y "$1")) / 3600 )); }

echo "== Backup freshness check (warn > ${WARN_H}h) =="

check_dir() {
  local label=$1 dir=$2 maxh=$3
  local newest
  newest=$(find "$dir" -maxdepth 2 -type f -mmin "-$((maxh*60))" 2>/dev/null | head -1)
  if [[ -n "$newest" ]]; then
    echo "[OK]   $label: $newest"
  else
    echo "[FAIL] $label: nothing newer than ${maxh}h under $dir"
    FAIL=1
  fi
}

check_file() {
  local label=$1 f=$2 maxh=$3
  if [[ -f "$f" ]]; then
    local a; a=$(age "$f")
    if (( a <= maxh )); then echo "[OK]   $label: ${a}h old ($f)"; else echo "[FAIL] $label: ${a}h old (>${maxh}h) ($f)"; FAIL=1; fi
  else
    echo "[FAIL] $label: file missing ($f)"
    FAIL=1
  fi
}

check_dir "OpenSearch local snapshots" /opt/wazuh-backups/elasticsearch "$WARN_H"
check_dir "Phase2 config bundles" "$ROOT/ops/backups" "$((WARN_H*2))"
check_file "DR S3 bundle log" /opt/wazuh-backups/dr-s3-cron.log 48
check_file "S3 snapshot log" /opt/wazuh-backups/snapshot-s3-cron.log 24
check_file "Local snapshot log" /opt/wazuh-backups/snapshot-cron.log 12
check_file "Wazuh config backup log" /opt/wazuh-backups/config-cron.log 72

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
exit $FAIL
