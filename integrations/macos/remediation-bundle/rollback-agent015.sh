#!/bin/bash
set -euo pipefail
MODE="${1:---list}"; BACKUP="${2:-}"; CONF="${WAZUH_OSSEC_CONF:-/Library/Ossec/etc/ossec.conf}"; BACKUP_DIR="${WAZUH_BACKUP_DIR:-/Library/Ossec/etc/mct-backups}"
case "$MODE" in
 --list) ls -lt "$BACKUP_DIR"/ossec.conf.*.bak 2>/dev/null || true;;
 --apply) [ "$(id -u)" -eq 0 ] || exit 2; [ -f "$BACKUP" ] || { echo "Backup required" >&2; exit 3; }; cp -p "$CONF" "$CONF.pre-rollback.$(date -u +%Y%m%dT%H%M%SZ)"; install -m 640 -o root -g wheel "$BACKUP" "$CONF"; /Library/Ossec/bin/wazuh-control restart 2>/dev/null || launchctl kickstart -k system/com.wazuh.agent 2>/dev/null || true; echo "Rollback applied";;
 *) echo "Usage: $0 --list | --apply /path/to/backup" >&2; exit 2;; esac
