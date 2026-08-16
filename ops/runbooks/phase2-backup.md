# Stack Configuration Backup Runbook

Purpose: extend the existing DR model to cover stack configuration and selected data.

## Backup categories

| Category | Policy | Mechanism | Notes |
|---|---|---|---|
| Configuration (compose, runbooks, scripts, integrations, reporting, README) | ALWAYS | `ops/scripts/backup-phase2-config.sh` | Daily cron; excludes .env, excludes ops/backups |
| Secrets | REFERENCE ONLY | Never backed up in plaintext | Back up `ops/creds.env` per the existing Wazuh backup procedure (already covered); never include in the stack archive |
| Case data (DFIR-IRIS) | REQUIRED if production | `pg_dump` iris-db -> ops/backups | Daily |
| MISP data | REQUIRED if production | mysqldump misp-db + /var/www/MISP config | Daily |
| Velociraptor config/artifacts | REQUIRED if production | config: backup-phase2-config.sh; artifacts: Filestore volume snapshot | Weekly |
| Shuffle workflows | REQUIRED | UI export JSON to ops/backups + volume | Weekly |
| OpenCanary config | REQUIRED | backup-phase2-config.sh (data/opencanary/opencanary.conf) | Daily |
| Greenbone data | REQUIRED if production | VM: pg_dump gvmd + /var/lib/gvmd | Weekly |
| Reports | OPTIONAL, recommended | `reporting/output` retained locally + DR bundle | Monthly |

## Exclusions

- `data/` volumes for services not yet production (documented).
- Elastiflow/Wazuh OpenSearch indices — handled by existing `elastic-snapshot-s3.sh`.
- `ops/backups` itself (recursion guard).

## Cron examples (INSTALLED 2026-08-10 — root crontab)

```cron
# Stack config backup (daily 04:00)
0 4 * * * /opt/mct-security-stack/ops/scripts/backup-phase2-config.sh >> /opt/mct-security-stack/ops/reports/backup-cron.log 2>&1

# IRIS DB dump (daily 04:30, 30-day retention)
30 4 * * * cd /opt/mct-security-stack/data/dfir-iris/iris-web && docker compose exec -T db pg_dump -U iris iris > /opt/mct-security-stack/ops/backups/iris-db-$(date +%Y%m%d-%H%M%S).sql && find /opt/mct-security-stack/ops/backups -name "iris-db-*.sql" -mtime +30 -delete

# MISP DB dump (daily 04:35 via SSH to mct-soc-scan, 30-day retention)
35 4 * * * ssh -i /root/.ssh/mct_soc_scan -o StrictHostKeyChecking=no root@192.168.222.154 "cd /opt/mct-security-stack && docker compose -f compose/docker-compose.misp.yml exec -T misp-db sh -c \"exec mysqldump -uroot -p\$MYSQL_ROOT_PASSWORD misp\"" > /opt/mct-security-stack/ops/backups/misp-db-$(date +%Y%m%d-%H%M%S).sql && find /opt/mct-security-stack/ops/backups -name "misp-db-*.sql" -mtime +30 -delete
```

## Verification

- `backup-phase2-config.sh` exit 0 and archive non-empty (tested 2026-08-10: 128 files).
- Monthly: restore test of the config archive into a scratch dir.
- Verify `ops/reports/backup-log.txt` grows daily.

## Rotation

- Keep 30 daily config archives; prune older (existing pattern in Wazuh backup scripts).
