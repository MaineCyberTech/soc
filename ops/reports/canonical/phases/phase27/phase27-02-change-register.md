# Phase 27 Change Register

Date: 2026-08-24

| # | Change | Owner | Approval | Backup | Rollback | Health gate | Evidence |
|---|---|---|---|---|---|---|---|
| C1 | 013/014 Sysmon certification (reapply/marker/24h) + throttle retirement | Operator (RMM) | APPROVED (P24/25) | effective dumps | rollback script | EID1/10 + buffer | marker + 24h |
| C2 | Windows certification + W1/W2 dashboards | SOC | GATED on C1 | - | - | certified telemetry | cert record |
| C3 | PS 4104 pilot (012) | SOC+op | PENDING | GPO backup | disable GPO | volume/privacy | pilot review |
| C4 | Shuffle workflow edits (dedup/rate-limit/malformed) | SOC | APPROVED (Class A scope) | workflow export | restore export | replay test | workflow version |
| C5 | Multi-index restore drill (p27-restore-*) | SOC | APPROVED (non-destructive) | snapshot intact | delete scratch | sources unchanged | counts/queries |
| C6 | v1.3.0 release | Operator | PENDING | tag | tag delete | all gates | release object |
| C7 | VT/indexer/PVE rotations | Operator | PENDING (replacement) | stores backup | restore | post-validation | records |
| C8 | NetFlow alert arming | SOC | PENDING (scope) | - | - | dry-run | arming record |

## Rules

- No live index deletion/closure for drills; no security/system/hidden index restore;
  snapshot files never deleted directly (APIs only).
- No fleet-wide 4104 before pilot privacy/volume review. No release without gates.

## No secrets