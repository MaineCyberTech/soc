# Sysmon Dashboard Backlog (Phase 4)

Dashboard panels to build once pilot data flows (after collection validated).

## Panels

| # | Panel | Query filter | Notes |
|---|---|---|---|
| P1 | Sysmon overview | `data.win.system.eventID` counts per host 24h | index wazuh-alerts-* |
| P2 | Process creation by image | Event 1, aggs image.keyword | spot LOLBins |
| P3 | Outbound connections | Event 3 by destinationIp | beaconing |
| P4 | DNS queries | Event 22 by queryName | CDB match later |
| P5 | Persistence changes | Event 12-14 registry | run keys/services |
| P6 | Rule 101xxx hits | rule.id in 101xxx | post tune-in |
| P7 | Agent health | agent.name = pilot, last-seen | onboarding panel |

## Data source notes

- Collection-only phase: events in `wazuh-archives-*` (no alert rules yet).
- After rules enabled (2-week tune-in): use `wazuh-alerts-*`.
- CDB-dependent panels (P4 DNS match, P5) stay disabled until MISP CDB validated (done in D2 - now eligible).

## Acceptance

- P1-P7 built after pilot collection confirmed.
- No broad deployment - single pilot endpoint only.
- Rollback documented in windows-sysmon-pilot-implementation.md.
