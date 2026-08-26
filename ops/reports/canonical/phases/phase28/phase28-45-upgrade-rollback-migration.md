# Phase 28 Upgrade / Rollback / Migration

Date: 2026-08-24

## Version transitions

| Transition | Precheck | Backup | Migration | Rollback boundary |
|---|---|---|---|---|
| bundle v1.2.0 -> v1.3.0 | CI/secret/audits/gates | bundle manifest + prior tag | config only (no schema migration) | tag revert + bundle restore |
| wazuh-manager/indexer patch | cluster health, disk | snapshots + config bundle | same-major image tag | keep prior image + volume untouched |
| config/profile drift | profile validation | canonical config commit | apply profile | restore committed config |
| endpoint policy (sysmon 4.90->4.91) | effective config check | `sysmon -s` dump backup | apply + restart + verify | rollback script (restore newest backup) |

## Failed-upgrade recovery

- Indexer/managers: restore snapshots (runbook 26); never `down -v`.
- Config: restore from git canonical (skip-worktree reconcile).
- Release: discard tag/release, re-issue prior.

## Guards

- All upgrades proceed through the approval register (02); no automatic major migration.
- Rollback boundaries recorded per component (canonical map 33).

## No secrets