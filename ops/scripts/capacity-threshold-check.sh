#!/usr/bin/env bash
# Phase 9 capacity threshold check - warns when disk/swap/thin-pool approach limits.
# Usage: bash capacity-threshold-check.sh   (or cron)
set -uo pipefail
source /opt/wazuh-docker/multi-node/ops/creds.env 2>/dev/null
: "${PVE_PASSWORD:?PVE_PASSWORD not set in creds.env}"

DISK_WARN=80    # % root disk
DISK_CRIT=90
SWAP_WARN=70    # % swap used
SWAP_CRIT=90
THIN_WARN=85    # % thin pool data
THIN_CRIT=95

FAILS=0

echo "=== Capacity threshold check $(date -u '+%Y-%m-%d %H:%M') ==="

# Root disk
PCT=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
echo "[disk] root used: ${PCT}% (warn ${DISK_WARN}, crit ${DISK_CRIT})"
if [ "$PCT" -ge "$DISK_CRIT" ]; then echo "[FAIL] root disk critical"; FAILS=1;
elif [ "$PCT" -ge "$DISK_WARN" ]; then echo "[WARN] root disk high"; FAILS=1; fi

# Swap
SWS=$(free | awk '/Swap:/ {printf "%d", $3*100/$2}')
echo "[swap] used: ${SWS}% (warn ${SWAP_WARN}, crit ${SWAP_CRIT})"
if [ "$SWS" -ge "$SWAP_CRIT" ]; then echo "[FAIL] swap critical"; FAILS=1;
elif [ "$SWS" -ge "$SWAP_WARN" ]; then echo "[WARN] swap high"; FAILS=1; fi

# Thin pool on .222 (via ssh if reachable)
if command -v sshpass >/dev/null && SSHPASS="${PVE_PASSWORD}" sshpass -e ssh -o StrictHostKeyChecking=no \
   -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 root@192.168.222.222 \
   "lvs pve/data -o data_percent --noheadings 2>/dev/null" 2>/dev/null | grep -q .; then
  TP=$(SSHPASS="${PVE_PASSWORD}" sshpass -e ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
       root@192.168.222.222 "lvs pve/data -o data_percent --noheadings --nosuffix 2>/dev/null" 2>/dev/null | tr -d ' ')
  echo "[thin] .222 pool: ${TP}% (warn ${THIN_WARN}, crit ${THIN_CRIT})"
  TP_INT=${TP%.*}
  if [ "$TP_INT" -ge "$THIN_CRIT" ]; then echo "[FAIL] thin pool critical"; FAILS=1;
  elif [ "$TP_INT" -ge "$THIN_WARN" ]; then echo "[WARN] thin pool high"; FAILS=1; fi
else
  echo "[thin] .222 unreachable - skipped"
fi

echo "=== Result: $([ $FAILS -eq 0 ] && echo PASS || echo ACTION REQUIRED) ==="
exit $FAILS
