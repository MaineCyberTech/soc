#!/usr/bin/env bash
# MCT endpoint deployment - macOS
# Installs Wazuh agent (+ optional Velociraptor client) on macOS (Intel + Apple Silicon).
# Designed for level.io: idempotent, logs to /var/log/mct-endpoint-install.log, non-zero exit on failure.
#
# Inputs (priority: CLI flag > env var > rendered placeholder > safe default):
#   WAZUH_MANAGER        (required unless --manager; default 142.105.190.25)
#   WAZUH_AGENT_GROUP    (env or --group; legacy alias MCT_AGENT_GROUP)
#   WAZUH_REG_PASSWORD   (required - encrypted variable; --reg-password or env)
#   WAZUH_AGENT_NAME     (optional; defaults to hostname)
#   WAZUH_VERSION        (default 4.14.7)
#   INSTALL_VELOCIRAPTOR (optional "yes" - requires VELO_CONFIG_URL or VELO_CONFIG_B64)
#   VELO_CONFIG_URL      (URL to client.config.yaml)
#   VELO_CONFIG_B64      (base64 of client.config.yaml)
#
# Flags: --manager --reg-password --group --agent-name --velo-config-b64
#        --velo-config-url --dry-run --print-config-redacted

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=lib/mct-env.sh
. "$SCRIPT_DIR/lib/mct-env.sh"

LOG=/var/log/mct-endpoint-install.log
DRY_RUN=0
PRINT_CONFIG=0

while [ $# -gt 0 ]; do
  case "$1" in
    --manager) WAZUH_MANAGER="${2:-}"; shift 2 ;;
    --reg-password) WAZUH_REG_PASSWORD="${2:-}"; shift 2 ;;
    --group) WAZUH_AGENT_GROUP="${2:-}"; shift 2 ;;
    --agent-name) WAZUH_AGENT_NAME="${2:-}"; shift 2 ;;
    --velo-config-b64) VELO_CONFIG_B64="${2:-}"; shift 2 ;;
    --velo-config-url) VELO_CONFIG_URL="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --print-config-redacted) PRINT_CONFIG=1; shift ;;
    *) echo "ERROR: unknown argument: $1"; exit 2 ;;
  esac
done

WAZUH_MANAGER="$(mct_get_var WAZUH_MANAGER 142.105.190.25)"
WAZUH_VERSION="$(mct_get_var WAZUH_VERSION 4.14.7)"
if mct_is_unset "${WAZUH_AGENT_GROUP:-}"; then WAZUH_AGENT_GROUP="$(mct_get_var MCT_AGENT_GROUP default)"; fi
WAZUH_REG_PASSWORD="$(mct_get_var WAZUH_REG_PASSWORD '')"
WAZUH_AGENT_NAME="$(mct_get_var WAZUH_AGENT_NAME "$(hostname -s)")"
INSTALL_VELOCIRAPTOR="$(mct_get_var INSTALL_VELOCIRAPTOR no)"

if mct_is_unset "$WAZUH_REG_PASSWORD"; then
  echo "ERROR: WAZUH_REG_PASSWORD is required (registration password enabled on master)"
  echo "  Set it in Level.io as an encrypted automation variable and pass via"
  echo "  --reg-password or WAZUH_REG_PASSWORD env."
  exit 2
fi
if [ "$DRY_RUN" -eq 1 ] || [ "$PRINT_CONFIG" -eq 1 ]; then
  echo "== MCT endpoint install (macOS) config =="
  mct_print_config WAZUH_MANAGER WAZUH_AGENT_GROUP WAZUH_AGENT_NAME WAZUH_VERSION \
    INSTALL_VELOCIRAPTOR --secret WAZUH_REG_PASSWORD
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "DRY RUN - no changes made."
    exit 0
  fi
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: must run as root (sudo)"
  exit 1
fi

exec > >(tee -a "$LOG") 2>&1
echo "=== MCT endpoint install (macOS) started $(date -u +%FT%TZ) ==="

# ---------------------------------------------------------------- Wazuh agent
if [ -x /Library/Ossec/bin/wazuh-agent ] || ls /Library/Ossec >/dev/null 2>&1; then
  echo "Wazuh agent already installed - skipping install"
else
  echo "installing Wazuh agent (pkg) $WAZUH_VERSION"
  curl -sL -o /tmp/wazuh-agent.pkg \
    "https://packages.wazuh.com/4.x/macos/wazuh-agent-$WAZUH_VERSION-1.pkg"
  installer -pkg /tmp/wazuh-agent.pkg -target / || { echo "ERROR: pkg install failed"; exit 1; }
  rm -f /tmp/wazuh-agent.pkg
fi

# ---------------------------------------------------------------- configure
OSSEC_CONF=/Library/Ossec/etc/ossec.conf
echo "configuring manager address: $WAZUH_MANAGER"
if grep -q '<address>' "$OSSEC_CONF" 2>/dev/null; then
  sed -i '' "s|<address>.*</address>|<address>$WAZUH_MANAGER</address>|" "$OSSEC_CONF"
else
  echo "WARN: ossec.conf address block not found - check install"
fi

# ---------------------------------------------------------------- enroll
KEYFILE=/Library/Ossec/etc/client.keys
if [ -s "$KEYFILE" ] && grep -q "$WAZUH_AGENT_NAME" "$KEYFILE" 2>/dev/null; then
  echo "agent already enrolled ($WAZUH_AGENT_NAME) - skipping"
else
  echo "enrolling agent as $WAZUH_AGENT_NAME into group $WAZUH_AGENT_GROUP"
  ENROLL_ARGS=(-m "$WAZUH_MANAGER" -A "$WAZUH_AGENT_NAME" -P "$WAZUH_REG_PASSWORD")
  if [ -n "$WAZUH_AGENT_GROUP" ] && [ "$WAZUH_AGENT_GROUP" != "default" ]; then
    ENROLL_ARGS+=(-G "$WAZUH_AGENT_GROUP")
  fi
  /Library/Ossec/bin/agent-auth "${ENROLL_ARGS[@]}" || { echo "ERROR: enrollment failed"; exit 1; }
fi

# ---------------------------------------------------------------- start
echo "starting Wazuh agent"
/Library/Ossec/bin/wazuh-control start >/dev/null 2>&1 || true
sleep 3
STATUS=$(/Library/Ossec/bin/wazuh-control status 2>/dev/null | grep -c running)
if [ "$STATUS" -ge 1 ]; then
  echo "OK: Wazuh agent running"
else
  echo "ERROR: agent not running"
  exit 1
fi

# ---------------------------------------------------------------- Velociraptor
if [ "$INSTALL_VELOCIRAPTOR" = "yes" ]; then
  echo "installing Velociraptor client"
  if mct_is_unset "${VELO_CONFIG_URL:-}" && mct_is_unset "${VELO_CONFIG_B64:-}"; then
    echo "WARN: no VELO_CONFIG_URL/VELO_CONFIG_B64 - skipping client"
  else
    if ! command -v velociraptor >/dev/null 2>&1; then
      ARCH=$(uname -m)
      case "$ARCH" in x86_64) VELO_ARCH=amd64;; arm64) VELO_ARCH=arm64;; *) VELO_ARCH=amd64;; esac
      curl -sL -o /usr/local/bin/velociraptor \
        "https://github.com/Velocidex/velociraptor/releases/download/v0.77.2/velociraptor-v0.77.2-darwin-${VELO_ARCH}"
      chmod +x /usr/local/bin/velociraptor
    fi
    if ! mct_is_unset "${VELO_CONFIG_B64:-}"; then
      echo "$VELO_CONFIG_B64" | base64 -d > /etc/velociraptor.client.yaml
    else
      curl -sL -o /etc/velociraptor.client.yaml "$VELO_CONFIG_URL"
    fi
    chmod 600 /etc/velociraptor.client.yaml
    sed -i '' 's|writeback_darwin: .*|writeback_darwin: /etc/velociraptor.writeback.yaml|' /etc/velociraptor.client.yaml
    /usr/local/bin/velociraptor --config /etc/velociraptor.client.yaml service install >/dev/null 2>&1 || true
    /usr/local/bin/velociraptor --config /etc/velociraptor.client.yaml service start >/dev/null 2>&1 || true
    echo "OK: Velociraptor client installed"
  fi
fi

echo "=== MCT endpoint install (macOS) completed $(date -u +%FT%TZ) ==="
exit 0
