#!/usr/bin/env bash
# proxmox-thinpool-report.sh - generate weekly capacity report for PVE .222.
# Usage: bash ops/scripts/proxmox-thinpool-report.sh
# Output: ops/reports/proxmox-thinpool-report-<ts>.md
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
REPORT_DIR=${REPORT_DIR:-$ROOT/ops/reports}
PVE_HOST=${PVE_HOST:-192.168.222.222}
CREDS=${CREDS:-/opt/wazuh-docker/multi-node/ops/creds.env}

# credential handling: read PVE password from creds.env without printing
PASS=""
[ -f "$CREDS" ] && PASS=$(grep -E "^(PVE|P2)_PASSWORD=" "$CREDS" | head -1 | cut -d= -f2- | tr -d "\"'\r")
[ -z "$PASS" ] && [ -n "${PVE_PASSWORD:-}" ] && PASS=$PVE_PASSWORD
if [ -z "$PASS" ]; then
  echo "ERROR: PVE password not found (set PVE_PASSWORD or add PVE_PASSWORD= to creds.env)"
  exit 1
fi

TS=$(date +%Y%m%d-%H%M%S)
OUT="$REPORT_DIR/proxmox-thinpool-report-$TS.md"
mkdir -p "$REPORT_DIR"

SSH() { SSHPASS="$PASS" sshpass -e ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$PVE_HOST "$@"; }

POOL=$(SSH 'lvs pve/data -o data_percent --noheadings --nosuffix 2>/dev/null | tr -d " "')
PVFREE=$(SSH 'pvs --noheadings -o pv_free 2>/dev/null | tr -d " " | head -1')

DISKS=$(SSH 'lvs pve -o lv_name,lv_size,data_percent --noheadings 2>/dev/null | grep disk | sort -k3 -rn')
UNUSED=$(SSH 'grep -hc "^unused" /etc/pve/qemu-server/*.conf 2>/dev/null | paste -sd+ | bc')

STATUS="OK"
[ "$(echo "$POOL" | awk -F. '{print $1}')" -ge 85 ] && STATUS="WARN (>=85%)"
[ "$(echo "$POOL" | awk -F. '{print $1}')" -ge 90 ] && STATUS="ACTION (>=90%)"
[ "$(echo "$POOL" | awk -F. '{print $1}')" -ge 95 ] && STATUS="EMERGENCY (>=95%)"

cat > "$OUT" <<EOF
# Proxmox Thin Pool Report

Date: $(date -u '+%Y-%m-%d %H:%M UTC')
Host: $PVE_HOST

## Pool status

| Metric | Value | Threshold |
|---|---|---|
| data thin pool usage | $POOL% | WARN 85 / ACTION 90 / EMERGENCY 95 |
| PV free | $PVFREE | |
| Status | **$STATUS** | |

## Disk usage by LV (sorted by data% - VM 201-205)

\`\`\`
$DISKS
\`\`\`

## Unused disk entries in VM configs

\`\`\`
$UNUSED
\`\`\`

## Recommendations

- If >= 90%: remove unused disks (verify first), then consider pool extension.
- If >= 95%: immediate action - extend pool or reduce VM disk usage.
- Windows Update growth on pilot VMs is disabled by policy.
EOF

echo "Wrote $OUT"
