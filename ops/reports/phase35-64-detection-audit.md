# Phase 35: Detection and Routing Quality Audit

Date: 2026-08-25

## Use-case coverage
| Use Case | Status | Evidence |
|---|---|---|
| Suricata SPAN capture | PROVEN | ens19, 9M+ packets, 0 drops |
| EVE JSON forwarding | PROVEN | eve.json + eve-alert.json |
| Wazuh decode | PROVEN | json decoder, rule 86601 |
| Alert indexing | PROVEN | OpenSearch wazuh-alerts-4.x-2026.08.25 |
| Canary E2E | PROVEN | Synthetic + real SPAN alert |
| Shuffle routing | NOT IMPLEMENTED | UI-gated, Phase 36 |

## No-alert integrity
- Stats events: not alert-generating (expected, "Too many fields" non-fatal)
- Zero-alert window: maintained P33-P34 before canary

## SID evidence
| SID | Source | Status |
|---|---|---|
| 2027967 | ET MALWARE LiLocked | PROVEN (synthetic canary) |
| 2210038 | SURICATA STREAM FIN | PROVEN (real SPAN) |

## Thresholds
- Rule 86601 firedtimes: 1 per alert (no suppression)
- Level: 3 (informational)
- No threshold violations

## False positives
- Both 86601 alerts are true positives
- No FP detected in observation window

## Wazuh rules
- 86600-86604: active (Suricata rules)
- JSON decoder: working for alert records (< 256 fields)

## Canary proof
- Synthetic record: MCT-CANARY-P35-TEST-002, SID 2027967
- Indexed with _id: 074hOqABXUSVSG3Wg9Bi
- E2E latency: < 60s

## Dedup/routing
- Not implemented (Phase 36)

## PASS — Detection quality confirmed
## No secrets
