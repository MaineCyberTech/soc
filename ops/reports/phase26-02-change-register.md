# Phase 26 Change Register

Date: 2026-08-23

| # | Change | Owner | Approval | Backup | Rollback | Health gate | Evidence |
|---|---|---|---|---|---|---|---|
| C1 | 013/014 Sysmon policy confirmation + throttle retirement | Operator (RMM) | APPROVED (P24/P25) | effective-config dumps | rollback script | EID1/10 + buffer | marker + volume |
| C2 | 015 closeout (04:22 08-23) | SOC | n/a | - | - | keepalive/volume/queue | 24h metrics |
| C3 | Zeek workflow hardening (dedup/rate-limit/kill-switch) | SOC | APPROVED (C3 P25) | workflow export | restore workflow | case volume | replay test |
| C4 | Snapshot restore drill (p26-restore-* scratch) | SOC | APPROVED (non-destructive) | snapshot intact | delete scratch index | source index untouched | counts/mappings |
| C5 | PS4104 pilot (012 only) | SOC+op | PENDING | GPO backup | disable GPO | volume/privacy | pilot metrics |
| C6 | v1.3.0 release | Operator | PENDING | tag | tag delete | all gates | release object |
| C7 | VT/indexer/PVE rotations | Operator | PENDING (replacement) | stores backup | restore | post-validation | records |
| C8 | NetFlow alert arming | SOC | PENDING (scope) | - | - | dry-run | arming record |

## Rules

- Snapshot restore: include_global_state:false, include_aliases:false, renamed scratch prefix
  only; never over live/alias/security indices; cleanup only after validation evidence.
- No broad routing/EID7 collection; no forced Suricata traffic; no release without gates.

## No secrets