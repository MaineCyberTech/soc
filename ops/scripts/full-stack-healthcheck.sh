#!/usr/bin/env bash
# full-stack-healthcheck.sh
# Consolidated health check for the full MCT stack.
# Writes latest report + timestamped report. Never prints secrets.
# Usage: full-stack-healthcheck.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
WAZUH=${WAZUH_STACK_ROOT:-/opt/wazuh-docker/multi-node}
TS=$(date +%Y%m%d-%H%M%S)
REPORT="$ROOT/ops/reports/full-stack-health-$TS.md"
LATEST="$ROOT/ops/reports/full-stack-health-latest.md"
mkdir -p "$ROOT/ops/reports"

if [[ -f "$WAZUH/ops/creds.env" ]]; then
  set -a; source "$WAZUH/ops/creds.env" 2>/dev/null; set +a
fi

row() { printf '| %s | %s | %s | %s |\n' "$1" "$2" "$3" "${4:-none}"; }
down() { docker ps --format '{{.Names}}' | grep -q "^$1$"; }
pinghost() { ping -c 1 -W 1 "$1" >/dev/null 2>&1; }
tcpopen() { timeout 3 bash -c "echo > /dev/tcp/$1/$2" >/dev/null 2>&1; }
secs() { date +%s; }
fresh() { local f=$1 lim=$2; [[ -f "$f" ]] && (( $(secs) - $(stat -c %Y "$f") < lim )); }

{
echo "# Full Stack Health - $TS"
echo
echo "| Component | Status | Evidence | Action Needed |"
echo "|---|---|---|---|"

# --- Wazuh core ---
if down multi-node-wazuh.master-1; then row "Wazuh master" OK "container running" none; else row "Wazuh master" "**FAIL**" "not running" investigate; fi
if down multi-node-wazuh.worker-1; then row "Wazuh worker" OK "container running" none; else row "Wazuh worker" "**FAIL**" "not running" investigate; fi
idx=$(curl -sk -m 8 -u "admin:${WAZUH_ADMIN_PASSWORD:-}" https://127.0.0.1:9200/_cluster/health 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('status','?'), d.get('number_of_nodes','?'))" 2>/dev/null || echo "unreachable")
case "$idx" in
  "green 3"|"green "*"3") row "Wazuh indexer cluster" OK "$idx" none ;;
  *) row "Wazuh indexer cluster" "**FAIL**" "$idx" investigate ;;
esac
if down multi-node-wazuh.dashboard-1; then row "Wazuh dashboard" OK "container running" none; else row "Wazuh dashboard" "**FAIL**" "not running" investigate; fi
if down multi-node-nginx-1; then row "nginx agent LB" OK "container running" none; else row "nginx agent LB" "**FAIL**" "not running" investigate; fi
if down wazuh-cloudflared; then row "Cloudflare tunnel" OK "container running" none; else row "Cloudflare tunnel" "**FAIL**" "not running" investigate; fi

# --- Flow ---
if down elastiflow; then row "ElastiFlow" OK "container running" none; else row "ElastiFlow" "**FAIL**" "not running" investigate; fi
if down flow-relay; then row "flow-relay" OK "container running" none; else row "flow-relay" "**FAIL**" "not running" investigate; fi

# --- Security Onion (packet ingestion -> feeds Wazuh via agent 008) ---
if pinghost 192.168.222.116; then row "Security Onion VM" OK "ping ok" none; else row "Security Onion VM" "**FAIL**" "ping failed" check VM; fi
if command -v sshpass >/dev/null 2>&1 && [ -n "${SO_SSH_PASSWORD:-}" ] && SSHPASS="${SO_SSH_PASSWORD}" sshpass -e ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 "${SO_SSH_USERNAME:-user}@192.168.222.116" "echo '${SO_SSH_PASSWORD}' | sudo -S docker ps --format '{{.Names}}' 2>/dev/null | grep -q so-suricata" 2>/dev/null; then
  row "SO suricata" OK "container running" none
else
  row "SO suricata" "**FAIL**" "container not reachable" check SO VM; fi

# --- Deception ---
if down mct-security-stack-opencanary-1; then row "OpenCanary" OK "container running" none; else row "OpenCanary" "**FAIL**" "not running" investigate; fi

# --- SOAR ---
if down shuffle-backend && down shuffle-frontend; then row "Shuffle" OK "backend+frontend up" none; else row "Shuffle" "**FAIL**" "backend/frontend down" run shuffle-healthcheck.sh; fi

# --- IR ---
if ss -tulpen 2>/dev/null | grep -q ':8443'; then row "DFIR-IRIS" OK "port 8443 listening" none; else row "DFIR-IRIS" "**FAIL**" "port 8443 down" investigate; fi
if down iriswebapp_nginx; then row "IRIS nginx" OK "container healthy" none; else row "IRIS nginx" "**FAIL**" "not running" investigate; fi

# --- EDR ---
if systemctl is-active --quiet velociraptor; then row "Velociraptor" OK "service active" none; else row "Velociraptor" "**FAIL**" "service inactive" investigate; fi

# --- MISP / Greenbone (VM) ---
if pinghost 192.168.222.154 || tcpopen 192.168.222.154 8443; then row "MISP/Greenbone VM" OK "reachable (tcp 8443)" verify apps; else row "MISP/Greenbone VM" "**FAIL**" "unreachable" check VM; fi

# --- Backup freshness ---
SNAP=/opt/wazuh-backups/elasticsearch
if [[ -d "$SNAP" ]] && [[ -n "$(find "$SNAP" -name 'snap-*.dat' -mmin -1440 2>/dev/null | head -1)" ]]; then
  row "Local snapshot" OK "snap file < 24h" none
else
  row "Local snapshot" "**FAIL**" "no snap file < 24h" run elastic-snapshot.sh
fi
if [[ -f /opt/wazuh-backups/dr-s3-cron.log ]] && (( $(secs) - $(stat -c %Y /opt/wazuh-backups/dr-s3-cron.log) < 172800 )); then
  row "S3/DR bundle" OK "dr-s3 log < 48h" none
else
  row "S3/DR bundle" "**FAIL**" "no recent DR bundle" run dr-s3-bundle.sh
fi
if [[ -f /opt/mct-security-stack/ops/backups/phase2-config-$(date +%Y%m%d)*.tar.gz ]] || find /opt/mct-security-stack/ops/backups -name 'phase2-config-*.tar.gz' -mmin -2880 2>/dev/null | grep -q .; then
  row "Phase2 config backup" OK "bundle < 48h" none
else
  row "Phase2 config backup" "**FAIL**" "no bundle < 48h" run backup-phase2-config.sh
fi

# --- Resources ---
USED=$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')
if (( USED < 80 )); then row "Root disk" OK "${USED}% used" none; else row "Root disk" "**WARN**" "${USED}% used" free space; fi
SWAPT=$(free -m | awk '/Swap:/ {print $2}'); SWAPU=$(free -m | awk '/Swap:/ {print $3}')
if (( SWAPT == 0 )) || (( SWAPU < SWAPT / 2 )); then row "Swap" OK "${SWAPU}M/${SWAPT}M used" none; else row "Swap" "**WARN**" "${SWAPU}M/${SWAPT}M used" high swap pressure; fi
MEMU=$(free -m | awk '/Mem:/ {print int($3*100/$2)}')
if (( MEMU < 90 )); then row "Memory" OK "${MEMU}% used" none; else row "Memory" "**WARN**" "${MEMU}% used" high memory usage; fi

# --- Cron ---
if crontab -l 2>/dev/null | grep -q 'elastic-snapshot'; then row "Cron (snapshot)" OK "entries present" none; else row "Cron (snapshot)" "**WARN**" "no entry" check crontab; fi
if [[ -f /etc/cron.d/wazuh-backups ]] && grep -q 'elastic-snapshot' /etc/cron.d/wazuh-backups; then row "Cron.d wazuh-backups" OK "file present" none; else row "Cron.d wazuh-backups" "**WARN**" "missing" reinstall cron file; fi
} > "$REPORT"

ln -sf "$REPORT" "$LATEST"
echo "Wrote $LATEST ($REPORT)"
FAILS=$(grep -cE '\*\*FAIL\*\*' "$REPORT" || true)
echo "FAIL count: $FAILS"
# Phase 24: exit nonzero when any component FAILs (automation-detectable health)
if [ "${FAILS:-0}" -gt 0 ]; then
  echo "HEALTHCHECK FAIL - $FAILS component(s) failed (see $REPORT)"
  exit 1
fi
exit 0
