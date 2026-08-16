# Phase 5 UniFi Noise After

Date: 2026-08-11, measured 10m window post-change (07:32Z restart)

## Verified

- **Churn rules (120505/120506/120509/120510/120512/120517/120520/120531/120532):
  0 alerts since 07:32Z restart** (last alert 07:31:55, pre-change).
- Security UniFi rules still alerting: 120518 (link down), 120501 (WAN drop),
  120527 (unknown device), 120528 (unknown DHCP), 120513 (memory pressure),
  120560 (DDNS) - at original levels.
- UniFi family total last 10m: 408 (was ~1,600/10m before change) - the
  remaining 408 are security-relevant rules, not churn.

## Before/after projection (24h)

| metric | before | after (projected) | delta |
|---|---|---|---|
| UniFi churn rules | ~117k/24h | ~0 (archived) | -117k |
| UniFi family total | 235,717 | ~118k | -50% |
| Total stack alerts | ~257k | ~140k | -45% |

## Disclosure

- Projection based on 10m verified window + rule-level proof (0 alerts since
  restart). Full 24h re-baseline scheduled after steady state.
- 120520/120505 counts in the 10m query were pre-restart backlog (timestamps
  verified 07:31:55 max).

## Remaining UniFi alerts (by design)

120518 link down (B), 120501 WAN drop (B, MITRE), 120527 unknown device (B),
120528 unknown DHCP (B), 120521 WPA replay (B), 120524 storm (B),
120513 memory pressure (B), 120560 DDNS (C) - analyst-reviewed daily.

## Class A integrity

OpenCanary 1210xx, MISP 1211xx, unknown exporter, lateral movement: intact
(verified in prior phases; unchanged rules).

## Files

- ops/reports/phase5-unifi-noise-before.md
- ops/reports/phase5-unifi-routing-applied.md
- ops/reports/phase5-unifi-noise-after.md (this file)
- integrations/wazuh/unifi-digest-routing-phase5.md
- reporting/templates/unifi-daily-digest.md
