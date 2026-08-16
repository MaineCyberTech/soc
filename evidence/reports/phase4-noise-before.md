# Phase 4 Noise Before (baseline)

Date: 2026-08-11, window: 24h before changes
Source: alert-volume-by-rule.sh (20260811-052509) + track_total_hits query

## Totals

- **Total alerts/24h: 520,670**
- osquery rule 24010: 263,490 (50.6%) - open_sockets/processes/startup_items inventory
- UniFi family (ubiquiti/unifi/firewall/dhcp groups): ~238k (45.7%)
- mct-portal + auditd: ~18k (3.5%)

## Top rules before

| rule.id | count | level | description |
|---|---|---|---|
| 24010 | 263,490 | 3 | osquery: $(osquery.name) query result |
| 120520 | 54,896 | 3 | 802.11r roaming handoff |
| 120527 | 51,749 | 4 | unknown device (MAC not in known-devices) |
| 120518 | 19,056 | 5 | LAN dropped |
| 120501 | 18,667 | 6 | WAN blocked/drop |
| 120531 | 15,342 | 3 | client kicked by kernel |
| 120521 | 15,148 | 6 | WPA replay failure |
| 120537 | 10,281 | 5 | mctportal warn/error |
| 120510 | 7,962 | 5 | client disconnected |
| 120532 | 7,671 | 3 | client kicked (rssi) |

Full list: ops/reports/alert-volume-by-rule-20260811-052509.md

## What this baseline is used for

- Compare against phase4-noise-after.md after tuning changes.
- Class A paths (OpenCanary 1210xx, MISP 1211xx, unknown exporter, lateral movement) unaffected by this baseline.
