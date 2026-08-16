#!/usr/bin/env bash
# vm103-misp-db-dump.sh
# Dumps the MISP database on VM 103 (mct-soc-scan) to a local backup dir on the VM.
# Run from the Wazuh host; pushes the dump to /opt/mct-security-stack/ops/backups.
# Usage: vm103-misp-db-dump.sh
# Never prints secrets.
set -uo pipefail

VM="192.168.222.154"
KEY="${MCT_SOC_SCAN_KEY:-$HOME/.ssh/mct_soc_scan}"
ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
TS=$(date +%Y%m%d-%H%M%S)
DEST="$ROOT/ops/backups/vm103"
mkdir -p "$DEST"

SSH="ssh -i $KEY -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8"

echo "== MISP DB dump (VM103) $TS =="
if ! $SSH root@"$VM" 'true' 2>/dev/null; then
  echo "ERROR: cannot reach VM103"
  exit 1
fi

REMOTE=/var/backups/mct
$SSH root@"$VM" "mkdir -p $REMOTE && docker exec mct-security-stack-misp-db-1 sh -c 'mariadb-dump -u misp -p\${MYSQL_PASSWORD} --all-databases --single-transaction --quick 2>/dev/null || mariadb-dump --all-databases --single-transaction --quick 2>/dev/null' > $REMOTE/misp-db-$TS.sql" 2>&1 | tail -2
echo "dump rc=$?"

$SSH root@"$VM" "gzip -f $REMOTE/misp-db-$TS.sql && ls -la $REMOTE/misp-db-$TS.sql.gz" 2>&1 | tail -2

echo "-- pull to Wazuh host --"
scp -i "$KEY" -o BatchMode=yes -o StrictHostKeyChecking=no "root@$VM:$REMOTE/misp-db-$TS.sql.gz" "$DEST/" 2>&1 | tail -1
ls -la "$DEST/misp-db-$TS.sql.gz" 2>/dev/null && echo "OK: pulled"

# retention: keep 14
ls -t "$DEST"/misp-db-*.sql.gz 2>/dev/null | tail -n +15 | xargs -r rm -f
echo "Done"
