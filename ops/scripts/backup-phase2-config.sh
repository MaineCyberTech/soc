#!/usr/bin/env bash
# Phase 2 config backup: compose files, runbooks, scripts, integrations,
# reporting, and small data files. Excludes volatile/massive data and secrets.
# Usage: backup-phase2-config.sh [--to /path]
set -uo pipefail

MCT_ROOT="${MCT_STACK_ROOT:-/opt/mct-security-stack}"
TS=$(date +%Y%m%d-%H%M%S)
DEST="${1:-/opt/mct-security-stack/ops/backups}"
[[ "${1:-}" == "--to" ]] && DEST="${2:-$DEST}"

mkdir -p "$DEST"
ARCHIVE="$DEST/phase2-config-$TS.tar.gz"

echo "Backing up phase 2 configuration to $ARCHIVE"
tar -czf "$ARCHIVE" \
  -C "$(dirname "$MCT_ROOT")" \
  --exclude='.env' \
  --exclude='creds.env' \
  --exclude='data/dfir-iris' \
  --exclude='data/velociraptor' \
  --exclude='data/misp' \
  --exclude='data/greenbone' \
  --exclude='data/shuffle' \
  --exclude='data/opencanary/opencanary.log' \
  --exclude='ops/backups' \
  --exclude='reporting/output' \
  "$(basename "$MCT_ROOT")/compose" \
  "$(basename "$MCT_ROOT")/ops/scripts" \
  "$(basename "$MCT_ROOT")/ops/runbooks" \
  "$(basename "$MCT_ROOT")/ops/reports" \
  "$(basename "$MCT_ROOT")/integrations" \
  "$(basename "$MCT_ROOT")/reporting" \
  "$(basename "$MCT_ROOT")/README.md" \
  "$(basename "$MCT_ROOT")/.gitignore" \
  "$(basename "$MCT_ROOT")/.env.example"

if [[ $? -eq 0 ]]; then
  echo "Backup written: $ARCHIVE"
  echo "$ARCHIVE" >> "$MCT_ROOT/ops/reports/backup-log.txt"
  chmod 600 "$ARCHIVE"
else
  echo "Backup FAILED" >&2
  exit 1
fi
