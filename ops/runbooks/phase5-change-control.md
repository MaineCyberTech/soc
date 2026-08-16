# Change Control

Window: 2026-08-11 07:00-09:00 UTC (operator working session)
Preflight: ops/reports/phase5-preflight-20260811-070610.md

## Scope

| Workstream | Risk | Wazuh impact | Rollback |
|---|---|---|---|
| Capacity stabilization | low | none (documentation + validation only) | n/a |
| P1 credential rotation | high | indexer auth if rotated | keep old until validated |
| UniFi digest routing | medium | analysisd restart if rule changes | restore local_rules.xml backup |
| D5 Greenbone drill | low | none | n/a |
| D7 Velociraptor drill | low | none | n/a |
| Backup cron install | low | none | remove cron lines |
| Canary build | low | none (VM) | delete VM |
| Client Zero onboarding | low | none | n/a |
| DR test plan | low | none (scratch only) | n/a |

## Gates

- [x] Indexer green, 3 nodes
- [x] Full-stack health 0 FAIL
- [x] Shuffle health PASS
- [x] Backup freshness PASS
- [x] Ports captured (phase5-current-port-state.txt)
- [x] Resource state captured (phase5-current-resource-state.md)
- [ ] Config backup before any Wazuh rule change

## Rules

1. One workstream at a time; verify after each.
2. No `docker compose down -v`.
3. Credential rotation: one at a time, validate before next, no revoke until validated.
4. Wazuh rule change: backup -> logtest -> analysisd restart both nodes -> before/after counts.
5. Class A routes (OpenCanary/MISP IOC/unknown exporter/lateral) never weakened.
6. No unapproved workload moves; no invasive scans; no broad Sysmon rollout.
7. Backup cron install requires operator approval.

## Post-window verification

```bash
/opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh
/opt/mct-security-stack/ops/scripts/shuffle-healthcheck.sh
/opt/mct-security-stack/ops/scripts/backup-dr-audit.sh
/opt/mct-security-stack/ops/scripts/soc-smoke-test.sh --dry-run
```
