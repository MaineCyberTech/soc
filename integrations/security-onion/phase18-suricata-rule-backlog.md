# Phase 18 Suricata Rule Backlog

| # | Detection | Rule basis | Priority |
|---|---|---|---|
| 1 | Suricata alert mapping | json decoder alert.signature | HIGH (when events flow) |
| 2 | Severity 1-2 alerts -> level 10 | alert.severity | HIGH |
| 3 | Category grouping (ET/emerging) | alert.category | MED |
| 4 | Suppress known-benign signatures | alert.signature | MED |

## Status

- No rules yet - wait for real Suricata events to map accurately (measurement-first).

## No secrets
