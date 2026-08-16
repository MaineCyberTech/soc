#!/usr/bin/env bash
# MCT endpoint deployment - Linux
# Installs Wazuh agent (+ optional Velociraptor client, osquery) on Debian/Ubuntu/RHEL/CentOS/Rocky/Fedora/Amazon Linux.
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
#   INSTALL_OSQUERY      (optional "yes")
#   MCT_AGENT_GROUP      (legacy alias for WAZUH_AGENT_GROUP)
#
# Flags:
#   --manager ADDR  --reg-password PW  --group NAME  --agent-name NAME
#   --velo-config-b64 B64  --velo-config-url URL  --osquery yes|no
#   --dry-run  --print-config-redacted
#
# Level.io: render automation vars/custom fields into args or env. Script
# variables are OUTPUT slots - not inputs.

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=lib/mct-env.sh
. "$SCRIPT_DIR/lib/mct-env.sh"

LOG=/var/log/mct-endpoint-install.log
DRY_RUN=0
PRINT_CONFIG=0

# ------------------------------------------------------------ arg parsing
while [ $# -gt 0 ]; do
  case "$1" in
    --manager) WAZUH_MANAGER="${2:-}"; shift 2 ;;
    --reg-password) WAZUH_REG_PASSWORD="${2:-}"; shift 2 ;;
    --group) WAZUH_AGENT_GROUP="${2:-}"; shift 2 ;;
    --agent-name) WAZUH_AGENT_NAME="${2:-}"; shift 2 ;;
    --velo-config-b64) VELO_CONFIG_B64="${2:-}"; shift 2 ;;
    --velo-config-url) VELO_CONFIG_URL="${2:-}"; shift 2 ;;
    --osquery) INSTALL_OSQUERY="${2:-}"; shift 2 ;;
    --sysmon) INSTALL_SYSMON="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --print-config-redacted) PRINT_CONFIG=1; shift ;;
    *) echo "ERROR: unknown argument: $1"; exit 2 ;;
  esac
done

# ------------------------------------------------------------ variable resolution
WAZUH_MANAGER="$(mct_get_var WAZUH_MANAGER 142.105.190.25)"
WAZUH_VERSION="$(mct_get_var WAZUH_VERSION 4.14.7)"
if mct_is_unset "${WAZUH_AGENT_GROUP:-}"; then WAZUH_AGENT_GROUP="$(mct_get_var MCT_AGENT_GROUP default)"; fi
WAZUH_REG_PASSWORD="$(mct_get_var WAZUH_REG_PASSWORD '')"
WAZUH_AGENT_NAME="$(mct_get_var WAZUH_AGENT_NAME "$(hostname -s)")"
INSTALL_VELOCIRAPTOR="$(mct_get_var INSTALL_VELOCIRAPTOR no)"
INSTALL_OSQUERY="$(mct_get_var INSTALL_OSQUERY no)"

# ------------------------------------------------------------ fail-fast
if mct_is_unset "$WAZUH_REG_PASSWORD"; then
  echo "ERROR: WAZUH_REG_PASSWORD is required (registration password enabled on master)"
  echo "  Set it in Level.io as an encrypted automation variable and pass via"
  echo "  --reg-password or WAZUH_REG_PASSWORD env."
  exit 2
fi
if [ "$DRY_RUN" -eq 1 ] || [ "$PRINT_CONFIG" -eq 1 ]; then
  echo "== MCT endpoint install (Linux) config =="
  mct_print_config WAZUH_MANAGER WAZUH_AGENT_GROUP WAZUH_AGENT_NAME WAZUH_VERSION \
    INSTALL_VELOCIRAPTOR INSTALL_OSQUERY --secret WAZUH_REG_PASSWORD
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "DRY RUN - no changes made."
    exit 0
  fi
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: must run as root"
  exit 1
fi

exec > >(tee -a "$LOG") 2>&1
echo "=== MCT endpoint install (Linux) started $(date -u +%FT%TZ) ==="

detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  elif command -v yum >/dev/null 2>&1; then
    echo "rhel"
  else
    echo "debian"
  fi
}
DISTRO=$(detect_distro)
echo "distro: $DISTRO (manager: $WAZUH_MANAGER, group: $WAZUH_AGENT_GROUP)"

# ---------------------------------------------------------------- Wazuh agent
install_wazuh_deb() {
  if command -v wazuh-agent >/dev/null 2>&1 || [ -x /var/ossec/bin/wazuh-agent ]; then
    echo "wazuh-agent already installed - skipping install"
    return 0
  fi
  echo "installing Wazuh agent (apt) $WAZUH_VERSION"
  curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import >/dev/null 2>&1
  chmod 644 /usr/share/keyrings/wazuh.gpg
  echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -y "wazuh-agent=$WAZUH_VERSION-1" || apt-get install -y wazuh-agent
}

install_wazuh_rpm() {
  if command -v wazuh-agent >/dev/null 2>&1 || [ -x /var/ossec/bin/wazuh-agent ]; then
    echo "wazuh-agent already installed - skipping install"
    return 0
  fi
  echo "installing Wazuh agent (rpm) $WAZUH_VERSION"
  rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH
  cat > /etc/yum.repos.d/wazuh.repo <<EOF
[wazuh]
gpgcheck=1
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH
enabled=1
name=WAZUH repository
baseurl=https://packages.wazuh.com/4.x/yum/
EOF
  yum install -y "wazuh-agent-$WAZUH_VERSION-1" 2>/dev/null || dnf install -y "wazuh-agent-$WAZUH_VERSION-1" 2>/dev/null || yum install -y wazuh-agent
}

configure_agent() {
  local ossec_conf=/var/ossec/etc/ossec.conf
  echo "configuring manager address: $WAZUH_MANAGER"
  sed -i "s|<address>.*</address>|<address>$WAZUH_MANAGER</address>|" "$ossec_conf"
  grep -q "$WAZUH_MANAGER" "$ossec_conf" || sed -i "s|<address>.*</address>|<address>$WAZUH_MANAGER</address>|" "$ossec_conf"
}

enroll_agent() {
  local keyfile=/var/ossec/etc/client.keys
  if [ -s "$keyfile" ] && grep -q "$WAZUH_AGENT_NAME" "$keyfile" 2>/dev/null; then
    echo "agent already enrolled ($WAZUH_AGENT_NAME) - skipping enrollment"
    return 0
  fi
  echo "enrolling agent as $WAZUH_AGENT_NAME into group $WAZUH_AGENT_GROUP"
  local args=(-m "$WAZUH_MANAGER" -A "$WAZUH_AGENT_NAME" -P "$WAZUH_REG_PASSWORD")
  if [ -n "$WAZUH_AGENT_GROUP" ] && [ "$WAZUH_AGENT_GROUP" != "default" ]; then
    args+=(-G "$WAZUH_AGENT_GROUP")
  fi
  /var/ossec/bin/agent-auth "${args[@]}"
  local rc=$?
  if [ $rc -ne 0 ]; then
    echo "ERROR: enrollment failed rc=$rc"
    exit 1
  fi
}

start_agent() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl enable --now wazuh-agent 2>/dev/null || systemctl restart wazuh-agent
    systemctl is-active --quiet wazuh-agent && echo "wazuh-agent active" || { echo "ERROR: wazuh-agent not active"; exit 1; }
  else
    /var/ossec/bin/wazuh-control start
    /var/ossec/bin/wazuh-control status | grep -q running || { echo "ERROR: agent not running"; exit 1; }
  fi
}

case "$DISTRO" in
  debian|ubuntu) install_wazuh_deb ;;
  rhel|centos|rocky|almalinux|fedora|amzn) install_wazuh_rpm ;;
  *) echo "ERROR: unsupported distro $DISTRO"; exit 1 ;;
esac

configure_agent
enroll_agent
start_agent
echo "OK: Wazuh agent installed and running"

# ---------------------------------------------------------------- Velociraptor
if [ "$INSTALL_VELOCIRAPTOR" = "yes" ]; then
  echo "installing Velociraptor client"
  if mct_is_unset "${VELO_CONFIG_URL:-}" && mct_is_unset "${VELO_CONFIG_B64:-}"; then
    echo "WARN: INSTALL_VELOCIRAPTOR=yes but no VELO_CONFIG_URL or VELO_CONFIG_B64 - skipping client"
  else
    if ! command -v velociraptor >/dev/null 2>&1; then
      ARCH=$(uname -m)
      case "$ARCH" in x86_64) VELO_ARCH=amd64;; aarch64) VELO_ARCH=arm64;; *) VELO_ARCH=amd64;; esac
      curl -sL -o /tmp/velociraptor https://github.com/Velocidex/velociraptor/releases/download/v0.77.2/velociraptor-v0.77.2-linux-${VELO_ARCH}
      chmod +x /tmp/velociraptor
      mv /tmp/velociraptor /usr/local/bin/velociraptor
    fi
    if ! mct_is_unset "${VELO_CONFIG_B64:-}"; then
      echo "$VELO_CONFIG_B64" | base64 -d > /etc/velociraptor.client.yaml
    else
      curl -sL -o /etc/velociraptor.client.yaml "$VELO_CONFIG_URL"
    fi
    chmod 600 /etc/velociraptor.client.yaml
    sed -i 's|writeback_linux: .*|writeback_linux: /etc/velociraptor.writeback.yaml|' /etc/velociraptor.client.yaml
    /usr/local/bin/velociraptor --config /etc/velociraptor.client.yaml service install >/dev/null 2>&1 || true
    /usr/local/bin/velociraptor --config /etc/velociraptor.client.yaml service start >/dev/null 2>&1 || true
    echo "OK: Velociraptor client installed"
  fi
fi

# ---------------------------------------------------------------- osquery
if [ "$INSTALL_OSQUERY" = "yes" ]; then
  echo "installing osquery"
  if ! command -v osqueryd >/dev/null 2>&1; then
    case "$DISTRO" in
      debian|ubuntu)
        export OSQUERY_KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "$OSQUERY_KEY" >/dev/null 2>&1
        add-apt-repository "deb [arch=amd64] https://pkg.osquery.io/deb deb main" >/dev/null 2>&1 || true
        apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y osquery
        ;;
      rhel|centos|rocky|almalinux|fedora|amzn)
        curl -sL https://pkg.osquery.io/rpm/GPG-KEY-osquery | rpm --import -
        cat > /etc/yum.repos.d/osquery.repo <<'EOF'
[osquery]
name=osquery
baseurl=https://pkg.osquery.io/rpm/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkg.osquery.io/rpm/GPG-KEY-osquery
EOF
        yum install -y osquery 2>/dev/null || dnf install -y osquery
        ;;
    esac
  fi
  echo "OK: osquery installed"
fi

echo "=== MCT endpoint install (Linux) completed $(date -u +%FT%TZ) ==="
exit 0
