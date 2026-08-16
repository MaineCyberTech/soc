# Backup Cron Operations

## Verified schedule

| Job | Time | Status |
|---|---|---|
| IRIS dump | daily 04:30 | PROVEN (12/13/14) |
| MISP dump | daily 04:35 | PROVEN (12/13/14) |
| Freshness | daily 06:15 | PROVEN |
| Greenbone | Sun 05:15 | pending (next Sun) |
| Shuffle export | Sun 05:45 | PROVEN |
| Prune | Sun 06:00 | PROVEN (--apply) |

## Weekly ops check (Monday)

```bash
ls -la ops/reports/*cron.log | tail
/opt/mct-security-stack/ops/scripts/phase5-backup-freshness-check.sh
grep -c pruned ops/reports/backup-prune-cron.log
```

## Failures

- backup-cron-troubleshooting.md
- Two consecutive failures -> open issue.

## Retention

IRIS 14d, MISP 14d, Greenbone 35d, Shuffle 56d (prune enforced, proven).
