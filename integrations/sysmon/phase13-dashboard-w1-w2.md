# Phase 13 Dashboard W1/W2 (Windows)

Date: 2026-08-16
Status: DEFINITIONS READY - import via Wazuh dashboard (OpenSearch saved objects)

## W1 - Windows Endpoint Health (agent 012)

| Panel | Query (index pattern: wazuh-alerts-4.x-*) | Data (24h) |
|---|---|---|
| Agent status | agent.id:012, latest timestamp | active |
| Channel flow | aggs: terms data.win.system.channel | Sysmon 452, Security 322, App 50, System 34 |
| Event volume trend | date_histogram timestamp (1h), filter agent.id:012 | 1371 events/24h |
| Syscheck | agent.id:012, syscheck recent | last run 20:15 (P12) |

## W2 - Sysmon Overview (agent 012)

| Panel | Query | Data (24h) |
|---|---|---|
| EID distribution | terms data.win.system.eventID, filter Sysmon channel | EID 1=233, EID 7=205, EID 10=14 |
| Top images | terms data.win.eventdata.image (EID 1) | (query ready) |
| Top processes | terms data.win.eventdata.process | (query ready) |
| Network (EID 3) | terms data.win.eventdata.destinationIp | (query ready) |
| VaultCli suppressed | rule.id:92153 count (post-suppression = 0) | suppression verified |

## Import path

1. Wazuh dashboard -> Discover -> create saved searches for the queries above.
2. Dashboard -> Create new -> add panels from saved searches.
3. Index pattern: wazuh-alerts-4.x-* (existing).

## Status notes

- Data verified live (2026-08-16 04:05 UTC) - queries return correct volumes.
- W1/W2 are the only buildable dashboards now; W4 (process detections) needs
  D1-D4 rules, W5 (PowerShell) needs PS ScriptBlockLogging enabled.

## No secrets

No secret values printed.
