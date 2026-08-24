#!/usr/bin/env bash
set -euo pipefail
: "${SURICATA_CONFIG:?Set SURICATA_CONFIG}"
suricata -T -c "$SURICATA_CONFIG"
grep -nE 'pcap-log:|file-store:|payload:' "$SURICATA_CONFIG" || true
echo 'Review output confirms syntax; operators must separately verify unwanted outputs are disabled.'
