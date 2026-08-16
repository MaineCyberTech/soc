#!/usr/bin/env bash
# es-snapshot-retention-report.sh - report ES snapshot repos (local + S3).
# Usage: bash ops/scripts/es-snapshot-retention-report.sh
# Requires: indexer reachable (creds.env for admin password).
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
REPORT_DIR=${REPORT_DIR:-$ROOT/ops/reports}
CREDS=${CREDS:-/opt/wazuh-docker/multi-node/ops/creds.env}
TS=$(date +%Y%m%d-%H%M%S)
OUT="$REPORT_DIR/es-snapshot-retention-report-$TS.md"
mkdir -p "$REPORT_DIR"

[ -f "$CREDS" ] && . "$CREDS" 2>/dev/null || true
AUTH="admin:${WAZUH_ADMIN_PASSWORD:-}"
BASE="https://127.0.0.1:9200"

{
  echo "# ES Snapshot Retention Report - $TS"
  echo
  for repo in wazuh-backup do-spaces; do
    echo "## Repo: $repo"
    curl -sk -u "$AUTH" "$BASE/_snapshot/$repo/_all" 2>/dev/null \
      | python3 -c "
import json,sys
d=json.load(sys.stdin)
snaps=d.get('snapshots',[])
print('  snapshots:', len(snaps))
if snaps:
    print('  oldest:', snaps[0].get('snapshot'), snaps[0].get('start_time','')[:16])
    print('  newest:', snaps[-1].get('snapshot'), snaps[-1].get('start_time','')[:16])
    states={}
    for s in snaps: states[s.get('state')]=states.get(s.get('state'),0)+1
    print('  states:', states)
"
  done
  echo
  echo "## Local repo disk"
  du -sh /opt/wazuh-backups/elasticsearch 2>/dev/null
  echo
  echo "## Policy"
  echo "- Local: keep 14 snapshots (rolling), then delete oldest."
  echo "- S3: keep 30 snapshots (rolling); config bundle per DR runbook."
  echo "- Review before destructive cleanup."
} > "$OUT"
echo "Wrote $OUT"
