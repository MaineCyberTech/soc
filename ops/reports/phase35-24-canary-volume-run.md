# Phase 35: Canary Volume Window

Date: 2026-08-25

## Observation window: 17:53Z - 18:30Z (37 minutes)

## Metrics

| Metric | Count |
|---|---|
| Canary triggers (synthetic) | 1 |
| Real SPAN alerts (SID 2210038) | 1 |
| Routes (Shuffle) | 0 (observe-only) |
| Duplicates | 0 |
| Suppressions | 0 |
| Malformed events | 0 |
| Failures | 0 |
| Recovery events | 0 |
| Operator workload | < 30min total investigation |
| Case quality | N/A (no IRIS cases created) |

## Alert breakdown (agent 016 today, 1,056 total)

| Rule | Count | Description |
|---|---|---|
| 554 | 184 | OSSEC agent-related |
| 2902 | 157 | Syscheck file modified |
| 2904 | 157 | Syscheck attribute changed |
| 2901 | 153 | Syscheck file added |
| 5502 | 133 | PAM login closed |
| 5501 | 130 | PAM login opened |
| 5715 | 106 | Syscollector |
| 23505 | 8 | Vulnerability detection |
| 87104 | 8 | Wazuh vulnerability |
| 86601 | 2 | Suricata Alert (our canary + real) |
| Others | 20 | Various |

## Quality assessment
- All rule 86601 alerts are true positives
- No noise from canary injection
- Agent 016 logcollector stable (eve.json: 14 events, eve-alert.json: 1 event)

## No secrets
