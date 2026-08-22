#!/bin/bash
set -euo pipefail
MODE="${1:---check}"
CONF="${WAZUH_OSSEC_CONF:-/Library/Ossec/etc/ossec.conf}"
BACKUP_DIR="${WAZUH_BACKUP_DIR:-/Library/Ossec/etc/mct-backups}"
QUERY='process == "sudo" OR process == "loginwindow" OR process == "securityd" OR process == "sshd" OR process == "tccd" OR process == "screensharingd" OR process == "logoutd" OR eventMessage CONTAINS "logout" OR eventMessage CONTAINS "session" OR subsystem BEGINSWITH "com.apple.Authorization" OR subsystem BEGINSWITH "com.apple.SystemConfiguration" OR subsystem BEGINSWITH "com.apple.loginwindow"'
check(){
  echo "Config: $CONF"; [ -f "$CONF" ] || { echo "ERROR: config not found" >&2; exit 3; }
  grep -n '<location>macos</location>\|MCT-PHASE22-BOUNDED-MACOS\|<query>' "$CONF" || true
  pgrep -alf 'wazuh-agentd|ossec-agentd' || true
}
apply(){
  [ "$(id -u)" -eq 0 ] || { echo "ERROR: run with sudo" >&2; exit 2; }
  [ -f "$CONF" ] || { echo "ERROR: config not found" >&2; exit 3; }
  mkdir -p "$BACKUP_DIR"; chmod 700 "$BACKUP_DIR"
  TS=$(date -u +%Y%m%dT%H%M%SZ); BACKUP="$BACKUP_DIR/ossec.conf.$TS.bak"; cp -p "$CONF" "$BACKUP"
  TMP=$(mktemp); export MCT_QUERY="$QUERY"
  perl -0777 -pe 's#\s*<localfile>(?:(?!</localfile>).)*?<location>\s*macos\s*</location>(?:(?!</localfile>).)*?</localfile>\s*#\n<!-- MCT-PHASE22 removed unbounded macOS localfile; backup retained -->\n#sig' "$CONF" > "$TMP"
  if ! grep -q 'MCT-PHASE22-BOUNDED-MACOS' "$TMP"; then
    BLOCK="  <!-- MCT-PHASE22-BOUNDED-MACOS -->
  <localfile>
    <log_format>macos</log_format>
    <location>macos</location>
    <query>${QUERY}</query>
  </localfile>"
    awk -v block="$BLOCK" '/<\/ossec_config>/{print block} {print}' "$TMP" > "$TMP.new"; mv "$TMP.new" "$TMP"
  fi
  command -v xmllint >/dev/null 2>&1 && xmllint --noout "$TMP"
  install -m 640 -o root -g wheel "$TMP" "$CONF"; rm -f "$TMP"
  if [ -x /Library/Ossec/bin/wazuh-control ]; then /Library/Ossec/bin/wazuh-control restart
  elif [ -x /Library/Ossec/bin/ossec-control ]; then /Library/Ossec/bin/ossec-control restart
  else launchctl kickstart -k system/com.wazuh.agent 2>/dev/null || true; fi
  echo "Applied. Backup: $BACKUP"; check
}
case "$MODE" in --check) check;; --apply) apply;; *) echo "Usage: $0 --check|--apply" >&2; exit 2;; esac
