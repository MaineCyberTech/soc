# Phase 30 Systemd and Cron Audit

Date: 2026-08-24
Tooling: p30-infrastructure-audit.sh.

## Crons (evidence)

| Cron | Schedule | Owner |
|---|---|---|
| zeek-classa-guardrail | */15 | ops/scripts (exec 100755, firing - verified) |
| backup-wazuh-config | 02:30 | wazuh-docker |
| vm103-greenbone-backup | Sun 05:15 | ops |
| phase5-backup-freshness | 06:15 | ops |
| prune-phase5-backups | Sun 06:00 | ops |
| snapshot | 5-hourly | ISM/docker |
| scorecard monthly | via runbook (ops/scripts) | reporting |

## Systemd

- systemctl --failed: none. Host services healthy.
- Units referenced by scripts documented; no orphan timers.

## Findings

- Cron scripts run with exec-mode policy (100755 all tracked .sh). No overlap/lock conflicts
  observed. Logs to ops/reports/*.log (gitignored).

## Verdict

- **PASS**.

## No secrets