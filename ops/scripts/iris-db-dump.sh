#!/usr/bin/env bash
# iris-db-dump.sh
# Dumps the DFIR-IRIS PostgreSQL database to ops/backups with retention.
# Usage: iris-db-dump.sh [--to /path]
# NOT enabled in cron by default - requires operator approval.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
DEST="${1:-$ROOT/ops/backups}"
TS=$(date +%Y%m%d-%H%M%S)
OUT="$DEST/iris-db-$TS.sql.gz"
mkdir -p "$DEST"

if ! docker ps --format '{{.Names}}' | grep -q '^iriswebapp_db$'; then
  echo "ERROR: iriswebapp_db container not running"
  exit 1
fi

# creds from .env only (never printed)
set -a; source "$ROOT/.env" 2>/dev/null; set +a
DBPASS="${DFIR_IRIS_DB_PASSWORD:-}"

# The deployed stack overrides compose defaults: read real user/db from container env
DBUSER=$(docker exec iriswebapp_db sh -c 'printenv POSTGRES_ADMIN_USER' 2>/dev/null | tr -d '\r')
DBNAME=$(docker exec iriswebapp_db sh -c 'printenv POSTGRES_DB' 2>/dev/null | tr -d '\r')
DBUSER="${DBUSER:-iris}"
DBNAME="${DBNAME:-iris}"

if [ -z "$DBPASS" ]; then
  echo "ERROR: DFIR_IRIS_DB_PASSWORD not available (check /opt/mct-security-stack/.env)"
  exit 1
fi

docker exec -e PGPASSWORD="$DBPASS" iriswebapp_db pg_dump -U "$DBUSER" -d "$DBNAME" \
  | gzip > "$OUT"

if [ -s "$OUT" ]; then
  echo "OK: $OUT ($(du -h "$OUT" | cut -f1))"
  # retention: keep 14
  ls -t "$DEST"/iris-db-*.sql.gz 2>/dev/null | tail -n +15 | xargs -r rm -f
else
  echo "ERROR: dump empty - removing"
  rm -f "$OUT"
  exit 1
fi
