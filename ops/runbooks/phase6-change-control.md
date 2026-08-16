# Change Control

Window: 2026-08-11 23:00+ (operator working session)
Preflight: ops/reports/phase6-preflight-*.md

## Scope

| Workstream | Risk | Wazuh impact | Rollback |
|---|---|---|---|
| PVE API repair | low (read-only ops) | none | revert creds |
| Velociraptor port rebind | medium | none | revert config port |
| P1 rotation | high | indexer auth if rotated | keep old until validated |
| Greenbone schedule setup | low | none (VM103) | remove schedule |
| Canary build | low | none (VM) | delete VM |
| Windows VM + Sysmon | low | agent only | remove agent/group |
| Archives decision | medium | filebeat config | restore backup |
| Backup cron verify | low | none | n/a |
| DR scratch | low | none (scratch) | cleanup |

## Gates

- [x] Health truthful (selftest PASS)
- [x] Cluster green, 3 nodes
- [x] Full-stack 0 FAIL
- [x] Shuffle PASS
- [x] Backups PASS
- [x] Noise suppression holds (0/0)

## Rules

1. One workstream at a time; verify after each.
2. No `docker compose down -v`; no volume deletion.
3. Credentials: rotate only with new protected values; validate before next.
4. Wazuh config changes: backup -> test -> restart both managers -> document.
5. Class A routes never weakened.
6. No invasive scans; no broad Sysmon rollout.
7. DR scratch: copies only, never production data.

## Post-window verification

```bash
/opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh
/opt/mct-security-stack/ops/scripts/healthcheck-selftest.sh
/opt/mct-security-stack/ops/scripts/shuffle-healthcheck.sh
/opt/mct-security-stack/ops/scripts/backup-dr-audit.sh
```
