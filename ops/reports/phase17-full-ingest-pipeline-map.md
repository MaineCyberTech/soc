# Phase 17 Full Ingest Pipeline Map

Date: 2026-08-16

## End-to-end ingest paths

| Source | Transport | Parser/Decoder | Destination | Status (24h) |
|---|---|---|---|---|
| Windows agents (013/014) | agent 012/013/014 -> Wazuh | sysmon_event1/7, eventchannel | alerts + archives | 1,301 + 537 events |
| macOS agent (015) | agent -> Wazuh | macOS decoders (tccd/loginwindow/sudo) + syslog | alerts + archives | 92 (improving) |
| Linux agents (006/007/011) | agent -> Wazuh | syslog/sshd decoders | alerts + archives | active |
| Remote syslog 15140 | tcp+udp -> master | syslog decoders | alerts | listener verified |
| OpenCanary (local + 202) | syslog -> 15140 | canary decoders (121007/121012/121014) | alerts | 0 hits today (idle) |
| UniFi | syslog -> 15140 | ubiquiti decoders | alerts | 0 today (idle) |
| ElastiFlow | netflow -> flow-relay -> indexer | elastiflow-flow-ecs indices | flows index | 10,000+ flows/24h |
| Security Onion (008) | zeek-forward -> agent 008 | ZEEK JSON lines (custom) | alerts + archives | 762 events/24h |
| Suricata (008) | eve.json -> agent 008 | suricata decoder | alerts | config present |
| Greenbone | reports/webhooks -> Shuffle -> IRIS | GMP + webhook | IRIS cases | lab proven; no critical |
| MISP | CDB lists -> Wazuh rules | misp-iocs list | alerts (matches) | 0 tagged matches today |
| Velociraptor | client -> server (8002) | exports/evidence | IRIS (manual) | server up; 5 clients |
| Shuffle | webhooks from Wazuh | workflows | IRIS cases | 13 containers |
| IRIS | Shuffle cases | case workflow | case evidence | containers up |
| Reporting | generators | templates | client scorecards | wired (white-label) |

## Storage flow

- alerts -> wazuh-alerts-4.x-* (rolling daily)
- archives -> wazuh-archives-4.x-* (rolling daily, ~11G total)
- flows -> elastiflow-flow-ecs-* (rollover)
- snapshots: local (14 kept) + S3 (37)

## Doc

- docs/INGEST-PIPELINE.md (updated with this map)

## No secrets

No secret values printed.
