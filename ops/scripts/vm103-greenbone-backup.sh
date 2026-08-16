#!/usr/bin/env bash
# vm103-greenbone-backup.sh
# Backs up Greenbone (gvmd) database + report exports on VM 103.
# Run from Wazuh host. Never prints secrets.
# Usage: vm103-greenbone-backup.sh
set -uo pipefail

VM="192.168.222.154"
KEY="${MCT_SOC_SCAN_KEY:-$HOME/.ssh/mct_soc_scan}"
ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
TS=$(date +%Y%m%d-%H%M%S)
DEST="$ROOT/ops/backups/vm103"
mkdir -p "$DEST"

SSH="ssh -i $KEY -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8"

echo "== Greenbone backup (VM103) $TS =="
if ! $SSH root@"$VM" 'true' 2>/dev/null; then
  echo "ERROR: cannot reach VM103"
  exit 1
fi

REMOTE=/var/backups/mct
$SSH root@"$VM" "mkdir -p $REMOTE && docker exec mct-security-stack-pg-gvm-1 sh -c 'pg_dump -U gvmd -d gvmd 2>/dev/null || pg_dump -U postgres -d gvmd 2>/dev/null' > $REMOTE/greenbone-gvmd-$TS.sql" 2>&1 | tail -2

$SSH root@"$VM" "gzip -f $REMOTE/greenbone-gvmd-$TS.sql && ls -la $REMOTE/greenbone-gvmd-$TS.sql.gz" 2>&1 | tail -2

echo "-- pull to Wazuh host --"
scp -i "$KEY" -o BatchMode=yes -o StrictHostKeyChecking=no "root@$VM:$REMOTE/greenbone-gvmd-$TS.sql.gz" "$DEST/" 2>&1 | tail -1
ls -la "$DEST/greenbone-gvmd-$TS.sql.gz" 2>/dev/null && echo "OK: pulled"

# retention: keep 14
ls -t "$DEST"/greenbone-gvmd-*.sql.gz 2>/dev/null | tail -n +15 | xargs -r rm -f
echo "Done"
