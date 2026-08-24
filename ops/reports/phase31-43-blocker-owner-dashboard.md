# Phase 31 Blocker / Owner Dashboard

Date: 2026-08-24
Status: **CREATED** (config/health-state-components.json BLOCKED items).

| Blocker | impact | owner | required input | next action | age | approval |
|---|---|---|---|---|---|---|
| Packet visibility ingest | raw-packet detection value | operator | Wazuh agent + EVE ingest + broader ruleset | SPAN live; benchmark PASSED (32MB/0 drops) | resolved benchmark | next: Phase 32 |
| Endpoint markers 013/014 | cert/throttle/dashboards | operator | RMM run | run check-sysmon-tune.ps1 | multi-phase | pending |
| Shuffle UI controls | native dedup/counter | operator | UI window | approve UI edit | multi-phase | pending |
| Fresh target | deployability PASS | operator | adequate target | provision/resize | multi-phase | pending |
| Credentials (VT/PVE/indexer/NetFlow/Redis/Greenbone) | integrations | operator | replacements/evidence | supply | multi-phase | pending |

## Runbook links

- Each row links to the owning runbook (44).

## No secrets
