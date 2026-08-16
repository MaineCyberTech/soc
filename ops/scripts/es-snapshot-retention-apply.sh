#!/usr/bin/env bash
# es-snapshot-retention-apply.sh - apply ES local snapshot retention cleanup.
# APPROVAL-GATED: refuses to delete unless APPROVED=true AND S3 healthy.
# Usage: APPROVED=true bash ops/scripts/es-snapshot-retention-apply.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
REPORT_DIR=${REPORT_DIR:-$ROOT/ops/reports}
CREDS=${CREDS:-/opt/wazuh-docker/multi-node/ops/creds.env}
APPROVED=${APPROVED:-false}
KEEP=${KEEP:-14}
DRY_ONLY=${DRY_ONLY:-true}
TS=$(date +%Y%m%d-%H%M%S)
OUT="$REPORT_DIR/es-snapshot-retention-apply-$TS.md"
mkdir -p "$REPORT_DIR"

[ -f "$CREDS" ] && . "$CREDS" 2>/dev/null || true
AUTH="admin:${WAZUH_ADMIN_PASSWORD:-}"
BASE="https://127.0.0.1:9200"

# 1. S3 health gate
S3=$(curl -sk -u "$AUTH" "$BASE/_snapshot/do-spaces/_all" 2>/dev/null | python3 -c "
import json,sys
snaps=json.load(sys.stdin).get('snapshots',[])
states={s.get('state') for s in snaps}
print('OK' if snaps and states=={'SUCCESS'} else 'FAIL')
" 2>/dev/null)

{
  echo "# ES Snapshot Retention Apply - $TS"
  echo
  echo "Approved: $APPROVED | Keep: $KEEP | S3 health: ${S3:-unknown} | Dry-run: $DRY_ONLY"
  echo
  if [ "$S3" != "OK" ]; then
    echo "ABORT: S3 snapshot health not confirmed. No local deletion."
    exit 1
  fi
  if [ "$APPROVED" != "true" ]; then
    echo "NO ACTION: approval marker missing (APPROVED=true + operator approval)."
    exit 0
  fi

  # 2. Build candidate list (oldest -> newest-KEEP)
  curl -sk -u "$AUTH" "$BASE/_snapshot/wazuh-backup/_all" 2>/dev/null | python3 -c "
import json,sys
snaps=json.load(sys.stdin).get('snapshots',[])
keep=int('$KEEP')
for s in snaps[:max(0,len(snaps)-keep)]:
    print(s.get('snapshot'))
" > /tmp/es-snap-del-candidates.txt
  echo "Candidates: $(wc -l < /tmp/es-snap-del-candidates.txt)"
  echo

  if [ "$DRY_ONLY" = "true" ]; then
    echo "DRY-RUN: would delete the following (no action taken):"
    head -5 /tmp/es-snap-del-candidates.txt
    echo "  ..."
    echo "Run with DRY_ONLY=false to execute."
    exit 0
  fi

  # 3. Execute deletions
  while read -r snap; do
    [ -z "$snap" ] && continue
    echo "Deleting $snap"
    curl -sk -u "$AUTH" -X DELETE "$BASE/_snapshot/wazuh-backup/$snap" 2>/dev/null | head -c 100
    echo
  done < /tmp/es-snap-del-candidates.txt

  # 4. Verify
  REMAIN=$(curl -sk -u "$AUTH" "$BASE/_snapshot/wazuh-backup/_all" 2>/dev/null | python3 -c "
import json,sys
print(len(json.load(sys.stdin).get('snapshots',[])))" 2>/dev/null)
  echo "Remaining local snapshots: $REMAIN"
  du -sh /opt/wazuh-backups/elasticsearch 2>/dev/null
} > "$OUT"
echo "Wrote $OUT"
