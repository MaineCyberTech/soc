# Phase 14 Dashboard W1/W2 Readiness

Date: 2026-08-16

## Data fields verified (indexer, agent 012 + 013)

| Field | Present | Used by |
|---|---|---|
| data.win.system.channel | YES | W1 channel flow |
| data.win.system.eventID | YES | W2 EID distribution |
| data.win.eventdata.image | YES | W2 top images |
| data.win.eventdata.imageLoaded | YES | W2 module loads |
| data.win.eventdata.process | YES (EID 1) | W2 top processes |
| data.win.eventdata.destinationIp | (EID 3, when present) | W2 network |
| agent.id / agent.name | YES | W1 per-agent |
| rule.level | YES | W1 alerts |

## Import/manual build procedure (Wazuh dashboard)

1. Open Wazuh dashboard -> Discover (index pattern: wazuh-alerts-4.x-*).
2. Create saved searches per panel (channel flow, EID distribution, top images).
3. Dashboard -> Create dashboard -> add panels from saved searches.
4. Save as "W1 Windows Endpoint Health" / "W2 Sysmon Overview".
5. Set time filter to 24h.

## Blockers

- External Windows expansion stays blocked until: 7-day FP re-measure < 10
  level>=9/day + dashboard build completed.

## No secrets
