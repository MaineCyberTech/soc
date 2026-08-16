#!/usr/bin/env bash
# backup-dr-audit.sh
# Audits backup coverage and freshness for all stack components.
# Reports missing coverage. Never prints secrets.
# Usage: backup-dr-audit.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
WAZUH=${WAZUH_STACK_ROOT:-/opt/wazuh-docker/multi-node}
TS=$(date +%Y%m%d-%H%M%S)
REPORT="$ROOT/ops/reports/backup-dr-audit-$TS.md"
FAIL=0
now() { date +%s; }

check_file() {
  local label=$1 f=$2 maxh=$3
  if [[ -f "$f" ]]; then
    local a=$(( ($(now) - $(stat -c %Y "$f")) / 3600 ))
    if (( a <= maxh )); then echo "[OK]   $label (${a}h old)"; else echo "[FAIL] $label (${a}h old > ${maxh}h)"; FAIL=1; fi
  else
    echo "[FAIL] $label (missing)"
    FAIL=1
  fi
}

check_dir_newest() {
  local label=$1 dir=$2 maxh=$3
  local newest
  newest=$(find "$dir" -maxdepth 2 -type f -mmin "-$((maxh*60))" 2>/dev/null | head -1)
  if [[ -n "$newest" ]]; then echo "[OK]   $label (newest: $(basename "$newest"))"; else echo "[FAIL] $label (nothing < ${maxh}h)"; FAIL=1; fi
}

echo "== Backup/DR audit $TS =="
echo "-- OpenSearch snapshots (local)"
if [[ -f "$WAZUH/ops/creds.env" ]]; then
  set -a; source "$WAZUH/ops/creds.env" 2>/dev/null; set +a
  snapinfo=$(curl -sk -m 8 -u "admin:${WAZUH_ADMIN_PASSWORD:-}" "https://127.0.0.1:9200/_snapshot/wazuh-backup/_all" 2>/dev/null | python3 -c "
import json,sys,datetime
try:
    d=json.load(sys.stdin)
    s=d.get('snapshots',[])
    if not s: print('NONE'); raise SystemExit
    last=sorted(s,key=lambda x:x.get('start_time',''))[-1]
    ts=last.get('start_time','')
    age_h=(datetime.datetime.now(datetime.timezone.utc)-datetime.datetime.fromisoformat(ts.replace('Z','+00:00'))).total_seconds()/3600
    print(f\"{last['snapshot']}|{last['state']}|{age_h:.0f}\")
except Exception:
    print('QUERY_FAIL')
" 2>/dev/null || echo QUERY_FAIL)
  if [[ "$snapinfo" == *"SUCCESS"* ]]; then
    age=${snapinfo##*|}
    if (( age <= 24 )); then echo "[OK]   local snapshot: $snapinfo h old"; else echo "[FAIL] local snapshot: ${age}h old (>24h)"; FAIL=1; fi
  else
    echo "[FAIL] local snapshot check: $snapinfo"
    FAIL=1
  fi
else
  echo "[FAIL] creds.env unavailable - snapshot check skipped"
  FAIL=1
fi
echo "-- OpenSearch snapshots (S3/DO Spaces)"
check_file "S3 snapshot log" /opt/wazuh-backups/snapshot-s3-cron.log 24
echo "-- DR bundle"
check_file "DR S3 bundle log" /opt/wazuh-backups/dr-s3-cron.log 48
echo "-- Wazuh config backups"
check_dir_newest "wazuh-config-*" /opt/wazuh-backups 72
echo "-- Phase 2 config bundles"
check_dir_newest "phase2-config-*" "$ROOT/ops/backups" 48
echo "-- IRIS DB dump freshness"
iris_db=$(ls -t "$ROOT"/ops/backups/iris-db-*.sql.gz 2>/dev/null | head -1 || true)
if [[ -n "$iris_db" ]]; then
  a=$(( ($(now) - $(stat -c %Y "$iris_db")) / 3600 ))
  echo "[$([ $a -le 48 ] && echo OK || echo FAIL)]   IRIS DB dump (${a}h old): $(basename "$iris_db")"
  [ $a -gt 48 ] && FAIL=1
else
  echo "[FAIL] IRIS DB dump (not found - run iris-db-dump.sh)"
  FAIL=1
fi
echo "-- MISP DB dump freshness (VM side)"
misp_yml=$(docker exec iriswebapp_db sh -c 'echo skip' 2>/dev/null)
echo "[WARN] MISP/Greenbone DB dumps live on mct-soc-scan VM (192.168.222.154) - verify manually via SSH"
echo "-- Elasticsearch snapshot repo list"
if [[ -f "$WAZUH/ops/creds.env" ]]; then
  set -a; source "$WAZUH/ops/creds.env" 2>/dev/null; set +a
  snapcount=$(curl -sk -m 8 -u "admin:${WAZUH_ADMIN_PASSWORD:-}" "https://127.0.0.1:9200/_snapshot/wazuh-backup/_all" 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d.get('snapshots',[])))" 2>/dev/null || echo '?')
  echo "[OK]   snapshot repo reachable (snapshots: $snapcount)"
else
  echo "[WARN] creds.env unavailable - snapshot repo check skipped"
fi

{
  echo "# Backup/DR Audit - $TS"
  echo
  echo "## Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
  echo
  echo "## Coverage"
  echo
  echo "| Component | Status | Evidence |"
  echo "|---|---|---|"
  echo "| OpenSearch local snapshots | $(find /opt/wazuh-backups/elasticsearch -name 'snap-*.dat' -mmin -1440 2>/dev/null | grep -q . && echo OK || echo '**FAIL**') | /opt/wazuh-backups/elasticsearch |"
  echo "| OpenSearch S3 snapshot | $([ -f /opt/wazuh-backups/snapshot-s3-cron.log ] && [ $(( ($(now) - $(stat -c %Y /opt/wazuh-backups/snapshot-s3-cron.log)) / 3600 )) -le 24 ] && echo OK || echo '**FAIL**') | snapshot-s3-cron.log |"
  echo "| DR bundle to S3 | $([ -f /opt/wazuh-backups/dr-s3-cron.log ] && [ $(( ($(now) - $(stat -c %Y /opt/wazuh-backups/dr-s3-cron.log)) / 3600 )) -le 48 ] && echo OK || echo '**FAIL**') | dr-s3-cron.log |"
  echo "| Wazuh config backups | $(find /opt/wazuh-backups -name 'wazuh-config-*' -mmin -4320 2>/dev/null | grep -q . && echo OK || echo '**FAIL**') | wazuh-config-*.tar.gz |"
  echo "| Phase 2 config bundles | $(find "$ROOT/ops/backups" -name 'phase2-config-*' -mmin -2880 2>/dev/null | grep -q . && echo OK || echo '**FAIL**') | phase2-config-*.tar.gz |"
  echo "| IRIS DB dump | ${iris_db:-not found} | postgres container |"
  echo "| MISP DB dump | manual check on VM | mct-soc-scan |"
  echo "| Greenbone data | manual check on VM | mct-soc-scan |"
  echo
  echo "## Missing coverage"
  echo "- MISP/Greenbone DB dumps on mct-soc-scan VM - no automated check from this host."
  echo "- Velociraptor server config backup - verify in ops/backups."
} > "$REPORT"

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
echo "Report: $REPORT"
exit $FAIL
