# VM 103 Backup / Restore Runbook

## Scope

VM 103 = mct-soc-scan (192.168.222.154) hosting MISP + Greenbone Community Edition.

## Backup scripts (run from Wazuh host)

| Script | What | Size | Frequency (proposed) |
|---|---|---|---|
| vm103-misp-db-dump.sh | MISP MariaDB dump (all DBs) | ~150 MB gz | daily |
| vm103-greenbone-backup.sh | Greenbone gvmd postgres dump | ~700 MB - 1.5 GB gz | weekly |
| shuffle-workflow-export.sh | Shuffle workflows export | small | weekly |
| vm103-backup-freshness-check.sh | freshness check | - | daily (with healthcheck) |

All pull to `/opt/mct-security-stack/ops/backups/vm103/` with 14-day retention.

## Important: Greenbone dump size

- gvmd DB is ~9.8 GB uncompressed / ~0.7-1.5 GB gzipped.
- pg_dump through SSH can take 5-15 minutes. **Do not interrupt** - run via
  nohup if pulling through the script (the script's inline scp can race the
  gzip; prefer: run dump on VM with nohup, then scp when complete).
- Disk: each weekly Greenbone backup ~1.5 GB; 14-day retention = ~3 GB peak.

## Restore

### MISP

```bash
gunzip -c misp-db-<ts>.sql.gz | \
  ssh -i ~/.ssh/mct_soc_scan root@192.168.222.154 \
  'docker exec -i mct-security-stack-misp-db-1 sh -c "mariadb -u misp -p\${MYSQL_PASSWORD} misp"'
# then restart misp-core: docker restart mct-security-stack-misp-core-1
```

### Greenbone (gvmd)

```bash
gunzip -c greenbone-gvmd-<ts>.sql.gz | \
  ssh -i ~/.ssh/mct_soc_scan root@192.168.222.154 \
  'docker exec -i mct-security-stack-pg-gvm-1 sh -c "psql -U gvmd -d gvmd"'
# then: docker exec mct-security-stack-gvmd-1 sh -c "gvmd --rebuild-gvmd-data"
# re-sync feed data (NVTs) - long running, do off-peak
```

### Shuffle workflows

- If API export JSON exists: Shuffle UI -> Workflows -> Import.
- Manual UI export path documented in shuffle-workflow-export.sh.

## Verification after restore

1. MISP: login + `misp-feed-health.sh` PASS.
2. Greenbone: gvmd `--rebuild-gvmd-data` completes; schedules visible.
3. Shuffle: `shuffle-healthcheck.sh` PASS; workflows list populated.

## Cron proposal (needs operator approval - see ops/cron/phase4-backup-cron.example)

```cron
30 2 * * * /opt/mct-security-stack/ops/scripts/vm103-misp-db-dump.sh >> /opt/mct-security-stack/ops/reports/vm103-backup.log 2>&1
0 3 * * 0  /opt/mct-security-stack/ops/scripts/vm103-greenbone-backup.sh >> /opt/mct-security-stack/ops/reports/vm103-backup.log 2>&1
0 3 * * 0  /opt/mct-security-stack/ops/scripts/shuffle-workflow-export.sh >> /opt/mct-security-stack/ops/reports/vm103-backup.log 2>&1
```

## Safety

- Scripts never print secrets (passwords referenced from container env, never echoed).
- Restores touch only MISP/Greenbone/Shuffle - never Wazuh data volumes.
- Greenbone feed re-sync after restore is long; schedule off-peak.
