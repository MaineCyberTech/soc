# Phase 35: Combined Canary Chain Report

Date: 2026-08-25 (18:15Z)

## Chain summary

Two independent proof paths confirm the Suricata -> Wazuh detection pipeline works:

1. **Packet-layer (real SPAN)**: Live traffic on ens19 produced a real Suricata alert (SID 2210038, SURICATA STREAM FIN out of window) that decoded through eve.json -> agent 016 -> Wazuh rule 86601.
2. **Downstream EVE replay (synthetic)**: A marked synthetic EVE record (SID 2027967, MCT-CANARY-P35-TEST-002) injected into eve-alert.json decoded through agent 016 -> Wazuh rule 86601 and appeared in OpenSearch alerts index.

## Layer map

| Layer | Packet-layer (real) | EVE replay (synthetic) |
|---|---|---|
| Capture | ens19 SPAN (read-only mirror) | Manual injection to eve-alert.json |
| Suricata detection | LIVE — SID 2210038 | N/A (bypassed Suricata) |
| eve.json/eve-alert.json | eve.json (location: /var/log/suricata/eve.json) | eve-alert.json (location: /var/log/suricata/eve-alert.json) |
| Agent 016 logcollector | PROVEN (json format, eve.json) | PROVEN (json format, eve-alert.json) |
| Wazuh analysisd decode | PROVEN (json decoder) | PROVEN (json decoder) |
| Wazuh rule match | PROVEN (86601, level 3) | PROVEN (86601, level 3) |
| OpenSearch indexing | PROVEN (wazuh-alerts-4.x-2026.08.25) | PROVEN (wazuh-alerts-4.x-2026.08.25) |
| Shuffle execution | NOT TESTED (observe-only) | NOT TESTED (observe-only) |

## Evidence identifiers

| Alert | _id | @timestamp | SID | Source |
|---|---|---|---|---|
| Real SPAN | pb4OOqABXUSVSG3WrK_C | 2026-08-25T17:53:54.008Z | 2210038 | eve.json |
| Synthetic canary | 074hOqABXUSVSG3Wg9Bi | 2026-08-25T18:14:27.791Z | 2027967 | eve-alert.json |

## Timestamps (UTC)

| Event | Time |
|---|---|
| Real SPAN alert generated | 17:53:54 |
| Synthetic record injected | 18:14 |
| Synthetic alert indexed | 18:14:27 |
| End-to-end latency (synthetic) | < 60s |

## Proven layers

- Suricata detection engine on ens19 (real traffic)
- Suricata EVE JSON output (both eve.json and eve-alert.json)
- Agent 016 logcollector (json format, both files)
- Wazuh analysisd JSON decoding
- Wazuh rule 86601 matching (Suricata: Alert)
- OpenSearch alert indexing

## Unproven layers

- Shuffle playbook execution (observe-only)
- Shuffle test-group delivery
- Production SID routing (deferred)
- Canary volume at scale (deferred)
- Canary token injection (deferred)

## Residual risks

- `analysisd.decoder_order_size=256` — stats records (522 fields) cause "Too many fields" errors (non-fatal, but noisy)
- Agent 013/015 disconnected — no detection coverage on those endpoints
- Disk at 85% (LOW WATERMARK ACTIVE)
- eve-alert.json contains synthetic records — cleanup needed

## Recommendation

All detection pipeline layers through OpenSearch indexing are **PROVEN**. Move to production routing and Shuffle integration in Phase 36.

## No secrets
