#!/usr/bin/env bash
# MCT endpoint uninstall - Linux/macOS
# Removes Wazuh agent (+ Velociraptor, osquery) - used for offboarding or reinstall.
# level.io: idempotent, exit 0 on success.
set -uo pipefail

LOG=/var/log/mct-endpoint-uninstall.log
exec > >(tee -a "$LOG") 2>&1
echo "=== MCT endpoint uninstall ($(uname -s)) started $(date -u +%FT%TZ) ==="

if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: must run as root"
  exit 1
fi

OS=$(uname -s)

# Wazuh agent
if [ "$OS" = "Darwin" ]; then
  /Library/Ossec/bin/wazuh-control stop >/dev/null 2>&1 || true
  pkill -f wazuh-agent >/dev/null 2>&1 || true
  rm -rf /Library/Ossec /Library/StartupItems/OSSEC
  launchctl unload /Library/LaunchDaemons/com.wazuh.agent.plist >/dev/null 2>&1 || true
  rm -f /Library/LaunchDaemons/com.wazuh.agent.plist
  echo "OK: Wazuh agent removed (macOS)"
else
  if command -v systemctl >/dev/null 2>&1; then
    systemctl stop wazuh-agent 2>/dev/null || true
    systemctl disable wazuh-agent 2>/dev/null || true
  fi
  pkill -f wazuh-agent >/dev/null 2>&1 || true
  if command -v dpkg >/dev/null 2>&1; then
    DEBIAN_FRONTEND=noninteractive dpkg --purge wazuh-agent 2>/dev/null || echo "WARN: dpkg purge failed"
  elif command -v rpm >/dev/null 2>&1; then
    rpm -e wazuh-agent 2>/dev/null || echo "WARN: rpm erase failed"
  fi
  rm -f /etc/yum.repos.d/wazuh.repo /etc/apt/sources.list.d/wazuh.list
  echo "OK: Wazuh agent removed (Linux)"
fi

# Velociraptor
if command -v velociraptor >/dev/null 2>&1; then
  velociraptor --config /etc/velociraptor.client.yaml service stop >/dev/null 2>&1 || true
  velociraptor --config /etc/velociraptor.client.yaml service remove >/dev/null 2>&1 || true
  rm -f /etc/velociraptor.client.yaml /etc/velociraptor.writeback.yaml
  rm -f /usr/local/bin/velociraptor
  echo "OK: Velociraptor removed"
fi

# osquery
if command -v osqueryd >/dev/null 2>&1; then
  if command -v dpkg >/dev/null 2>&1; then
    DEBIAN_FRONTEND=noninteractive dpkg --purge osquery 2>/dev/null || true
  else
    rpm -e osquery 2>/dev/null || true
  fi
  rm -f /etc/yum.repos.d/osquery.repo
  echo "OK: osquery removed"
fi

echo "=== MCT endpoint uninstall completed $(date -u +%FT%TZ) ==="
exit 0
