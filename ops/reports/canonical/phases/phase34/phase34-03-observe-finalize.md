# Phase 34 Observe Window Finalization

Date: 2026-08-25 (17:35Z)

## Window
- Start: 2026-08-24T00:20Z (sensor deployment)
- End: 2026-08-25T17:35Z (current, ~17h elapsed)
- Scope: SPAN on ens19 (MTU 9000), observe-only, 529 ET Open rules (15 failed to load)

## Traffic / Processing
- Packets processed: 8,328,441 (rate: ~135 pps avg)
- Kernel drops: 0 (0.000%)
- NIC pre-existing drops: 9 (before sensor, historical)
- Errors: 0

## Detection
- Alerts fired: 0
- Alerts suppressed: 148 (ET thresholds)
- Alert queue overflow: 0
- Rules loaded: 529 / failed: 15

## EVE
- eve.json: fresh (17s age), ~1092 lines (stats events, 1/60s)
- eve-alert.json: not created (0 alerts)
- Event types: stats only (no alerts, no flow, no http/dns/tls logged)

## Resources
- Memory: 74MB current / 74MB peak
- PSI: 0 (no memory pressure)
- CPU: ~1.2%

## Wazuh
- Agent 016: active, keepalive fresh
- Events indexed: 0 (eve-alert.json not created = correct for 0 alerts)
- Decoder tested: SID 2027967 proven via logtest (level 3)

## FP Review
- 0 live FPs (0 alerts total)
- Offline FP review: sid 2027967 fired only on crafted malicious request (no collateral)

## Assessment
- Zero-alert window is COMPATIBLE with healthy processing (stats counters incrementing, eve fresh, memory stable, no drops, rules loaded)
- Window is authoritative for the benign profile

## No secrets
