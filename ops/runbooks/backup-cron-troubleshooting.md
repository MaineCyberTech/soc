# Backup Cron Troubleshooting

## Logs

| Job | Log |
|---|---|
| IRIS | ops/reports/iris-db-cron.log |
| MISP | ops/reports/vm103-misp-cron.log |
| Greenbone | ops/reports/vm103-greenbone-cron.log |
| Shuffle | ops/reports/shuffle-export-cron.log |
| Freshness | ops/reports/phase5-freshness-cron.log |
| Prune | ops/reports/backup-prune-cron.log |

## Common failures

| Symptom | Cause | Fix |
|---|---|---|
| IRIS dump empty/fails | DFIR_IRIS_DB_PASSWORD not in .env | source .env (0600) |
| MISP dump 48-byte file | mariadb-dump auth (user misp) | script uses MYSQL_PASSWORD from container env - verify VM reachable |
| Greenbone dump truncated | scp raced gzip (nohup pattern) | run dump on VM with nohup; verify gzip -t before scp |
| Shuffle export empty | SHUFFLE_API_KEY missing | set in .env |
| Prune dry-run only | no --apply | cron uses --apply (verified) |

## Checks

```bash
/opt/mct-security-stack/ops/scripts/phase5-backup-freshness-check.sh
/opt/mct-security-stack/ops/scripts/prune-phase5-backups.sh   # dry-run
ls -la /opt/mct-security-stack/ops/backups/ | head
```

## Escalation

- Two consecutive failures: open issue, check VM103 SSH key, disk, .env integrity.
- Disk < 20% free: prune manually + review retention.
