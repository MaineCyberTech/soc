# Phase 15 Integration Health Matrix

Date: 2026-08-16

| Integration | Direction | Health | Last verified |
|---|---|---|---|
| SO zeek-forward -> agent 008 -> Wazuh | packet -> SIEM | OK | 2026-08-16 (fresh lines) |
| SO suricata eve.json -> agent 008 | alert -> SIEM | OK | config present |
| Remote syslog 15140 (tcp+udp) | devices -> Wazuh | OK | P12 CI |
| OpenCanary -> Wazuh rules | deception -> alert | OK | last hit 08-15 23:25 |
| Greenbone -> Shuffle webhook -> IRIS | vuln -> SOAR -> case | READY | schedule proven; no critical yet |
| Wazuh alerts -> Shuffle workflows | SIEM -> SOAR | OK | 13 shuffle containers |
| IRIS case workflow | SOAR -> DFIR | OK | containers up |
| MISP IOC ingestion | threat intel | OK | on VM103 |
| Velociraptor clients -> server | endpoint collection | OK | server :8002, client process active |
| ElastiFlow -> indexer | netflow -> search | OK | 10k+ flows/24h |
| Level.io -> endpoint install | MDM -> deploy | OK | 013 deployed |
| Config backup cron | nightly | OK | 146KB valid |
| ES S3 snapshots | DR data | OK | 37 SUCCESS |
| Client scorecard/billing | reporting | OK | cycle started |

## Watch

- OpenCanary zero hits 24h (no triggers - expected).
- Velociraptor native-vs-container source of truth (doc fix P15.03).

## No secrets
