# Phase 35: Client Billing Certification

Date: 2026-08-25

## Billable coverage

| Service | Status | Billable |
|---|---|---|
| Packet capture (Suricata/SPAN) | OPERATIONAL | YES |
| Detection (ET Open rules) | OPERATIONAL | YES |
| Wazuh agent monitoring | OPERATIONAL | YES |
| Alert indexing (OpenSearch) | OPERATIONAL | YES |
| Shuffle routing | NOT IMPLEMENTED | PARTIAL |
| IRIS case management | UP (not routing) | PARTIAL |
| ElastiFlow NetFlow | OPERATIONAL | YES |
| Backup/retention | OPERATIONAL | YES |

## Endpoint connectivity
- 7/10 agents active — 70% coverage
- 3 disconnected (1 retired, 2 pending operator-RMM)

## Limitations
- Shuffle-native routing: Phase 36 (UI-gated)
- Production SID routing: deferred
- Agent 013/015: disconnected

## Certification
- **PARTIAL** — core detection and monitoring operational
- Routing and case management not yet integrated

## No secrets
