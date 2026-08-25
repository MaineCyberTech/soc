# Phase 36: Alert Routing Assessment

Date: 2026-08-25

## Current routing
| Source | Destination | Method | Status |
|---|---|---|---|
| Suricata | eve.json | SPAN | ACTIVE |
| eve.json | Wazuh | agent 016 | ACTIVE |
| Wazuh | IRIS | Shuffle workflow | NOTIFY-ONLY |
| Wazuh | OpenSearch | Wazuh indexer | ACTIVE |

## Missing routes
| Route | Status | Blocker |
|---|---|---|
| Wazuh → Shuffle webhook | NOT CONFIGURED | Password reset |
| Shuffle → IRIS (live) | NOTIFY-ONLY | Needs real trigger data |
| Suricata → Shuffle | NOT CONFIGURED | No direct path |

## Assessment
- Core routing: ACTIVE (Wazuh → OpenSearch → dashboards)
- Alert enrichment: DEFERRED (Shuffle workflow)
- No changes made

## No secrets
