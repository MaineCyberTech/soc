# Backup Cron Operations

## Schedule

| Job | Time | Log |
|---|---|---|
| IRIS dump | daily 04:30 | ops/reports/iris-db-cron.log |
| MISP dump | daily 04:35 | ops/reports/vm103-misp-cron.log |
| Greenbone dump | Sun 05:15 | ops/reports/vm103-greenbone-cron.log |
| Shuffle export | Sun 05:45 | ops/reports/shuffle-export-cron.log |
| Freshness | daily 06:15 | ops/reports/phase5-freshness-cron.log |
| Prune (--apply) | Sun 06:00 | ops/reports/backup-prune-cron.log |

## Weekly ops check (Monday)

```bash
ls -la /opt/mct-security-stack/ops/reports/*cron.log | tail
/opt/mct-security-stack/ops/scripts/phase5-backup-freshness-check.sh
grep -c pruned /opt/mct-security-stack/ops/reports/backup-prune-cron.log
```

## Failures

- See backup-cron-troubleshooting.md.
- Two consecutive failures -> open issue + check VM103 SSH, .env, disk.

## Retention

- Prune enforces: IRIS 14d, MISP 14d, Greenbone 35d, Shuffle 56d.
- Manual prune: prune-phase5-backups.sh --apply (dry-run default).
