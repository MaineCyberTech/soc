# Phase 28 Storage and Data Migration Audit

Date: 2026-08-24

## Volumes (~40, evidence)

| Volume group | Contents | Backup | Restore | Destructive risk |
|---|---|---|---|---|
| multi-node_wazuh-indexer-data-{1,2,3} | OpenSearch data (~21GB) | snapshots (42, FS /snapshots) + S3 bundle | index restore drills (P26/P27) | HIGH - never `down -v` |
| multi-node_wazuh-{etc,logs,queue,...} | manager config/logs/queue | config bundle (04:00 S3) | bundle restore | MEDIUM |
| iris-web_{db_data,...} | IRIS db/downloads/templates | (backup runbook) | documented | MEDIUM |
| mct-security-stack_shuffle-database | Shuffle db | workflow export | export restore | MEDIUM |
| multi-node_elastiflow-data | flow cache | n/a (re-index from collectors) | re-ingest | LOW |
| portainer_data | portainer | n/a | - | LOW |
| mct-security-stack_opencanary-logs | canary logs | alerts (Wazuh) | - | LOW |

## Ownership / perms / sizes

- Host root filesystem: 81% used (~21GB OpenSearch data). Snapshot volume /snapshots
  (docker volume). Backups at /opt/mct-security-stack-backups + /opt/wazuh-backups.

## Retention (data lifecycle)

- Alerts 30d, archives 14d (ISM), states ~30d, elastiflow 14d, snapshots 7d rolling.
  Next archive delete wave 08-29..09-01 (~7.4GB).

## Migration notes

- Scratch-restore namespacing supported via rename_pattern/replacement (proven P26/P27).
- No data streams (daily indices) - migration = reindex-on-restore or snapshot restore.

## Destructive-risk controls

- No `docker compose down -v` (runbook-enforced); snapshot repository files API-only
  (never manual delete); bundle build excludes data/ (secrets/keys gate).

## No secrets