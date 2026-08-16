# Phase 7 Change Control

Window: 2026-08-12 (operator working session)
Preflight: ops/reports/phase7-preflight-*.md

## Scope

| Workstream | Risk | Wazuh impact | Rollback |
|---|---|---|---|
| Endpoint kit audit | low | none | n/a |
| Level.io rollout plan | low | none (docs) | n/a |
| Linux pilot (local sim) | low | agent add | remove agent |
| macOS/Windows pilot | none (blocked) | n/a | n/a |
| Velociraptor hunt | low | none | n/a |
| Backup cron verification | low | none | n/a |
| MSP packaging | low | none | n/a |
| Scorecard generation | low | none | n/a |

## Gates

- [x] Full-stack 0 FAIL
- [x] Healthcheck selftest PASS
- [x] Shuffle PASS
- [x] Velociraptor 8002 + 2 clients
- [x] Endpoint kit 10 files present

## Rules

1. No broad endpoint rollout - one-device pilots only.
2. No Sysmon broad deployment.
3. No secrets printed; encrypted variables in level.io.
4. Endpoint scripts stay idempotent + reversible.
5. No invasive scans; no destructive actions.
6. No Wazuh core config changes without backup + validation.

## Post-window verification

```bash
/opt/mct-security-stack/ops/scripts/full-stack-healthcheck.sh
/opt/mct-security-stack/ops/scripts/healthcheck-selftest.sh
/opt/mct-security-stack/ops/scripts/backup-dr-audit.sh
```
