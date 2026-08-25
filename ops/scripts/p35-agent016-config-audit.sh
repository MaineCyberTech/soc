#!/usr/bin/env bash
set -euo pipefail
CONF=${OSSEC_CONF:-/var/ossec/etc/ossec.conf}; OUT=${OUT:-/tmp/p35-agent016-config-$(date +%Y%m%d-%H%M%S)}; mkdir -p "$OUT"
cp "$CONF" "$OUT/ossec.conf.snapshot"
grep -n -A4 -B2 '/var/log/suricata/eve' "$CONF" > "$OUT/suricata-localfiles.txt" || true
sha256sum "$CONF" > "$OUT/ossec.sha256"
systemctl status wazuh-agent --no-pager > "$OUT/agent-status.txt" 2>&1 || true
echo "Wrote $OUT"
