# Backup Retention Runbook

## Retention policy

| Stream | Keep | Location |
|---|---|---|
| IRIS DB dumps | 14 days | ops/backups/iris-db-*.sql.gz |
| MISP DB dumps | 14 days | ops/backups/vm103/misp-db-*.sql.gz |
| Greenbone gvmd dumps | 35 days | ops/backups/vm103/greenbone-gvmd-*.sql.gz |
| Shuffle workflow exports | 56 days | ops/backups/shuffle-workflows/*.json |
| OpenSearch snapshots (local) | 7 (cron-managed) | /opt/wazuh-backups/elasticsearch |
| S3 snapshots | 30 days (cron-managed) | DO Spaces |
| Stack config bundles | NOT pruned (manual review) | ops/backups/phase2-config-* |
| Secret key txt files | NEVER pruned | ops/backups/*.txt |

## Prune command

```bash
# dry-run first
/opt/mct-security-stack/ops/scripts/prune-phase5-backups.sh
# apply after review
/opt/mct-security-stack/ops/scripts/prune-phase5-backups.sh --apply
```

Only the 4 explicit patterns above are ever pruned. phase2-config tarballs,
compose .bak files, and secret txt files are excluded by design.

## Freshness check

```bash
/opt/mct-security-stack/ops/scripts/phase5-backup-freshness-check.sh
```

## Cron (final file, not auto-installed)

`ops/cron/phase5-backup-cron.final` - install via crontab -e (user) with
operator approval. Includes: IRIS daily 04:30, MISP daily 04:35, Greenbone
weekly Sun 05:15, Shuffle weekly Sun 05:45, freshness daily 06:15, prune weekly Sun 06:00.

## Disk impact

- Greenbone dumps ~1.8 GB/week at 35-day retention: ~9 GB peak.
- MISP dumps ~150 MB/day at 14-day: ~2.1 GB.
- Host disk currently 77% - prune keeps it bounded; monitor df weekly.

## Safety

- Prune never touches: Wazuh volumes, OpenSearch repos, S3, secret files.
- DR bundle and snapshot retention handled by existing cron scripts.
