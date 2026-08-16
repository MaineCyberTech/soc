# Phase 9 Local Snapshot Retention Review

Date: 2026-08-15
Scope: OpenSearch local snapshots (repo `wazuh-backup`, /opt/wazuh-backups/elasticsearch)

## Inventory

| Item | Value |
|---|---|
| Local snapshots | 41 (2026-08-09 02:35 -> 2026-08-15 15:17) |
| All states | SUCCESS |
| Storage | 12G |
| Frequency | every 5h (cron 17 */5) |
| Retention (configured) | 7 days (KEEP=7 in elastic-snapshot.sh) |
| Indices covered | 63 |

## Assessment

- Local snapshots provide fast restore (same-host) for OpenSearch indices.
- S3 snapshots (repo `do-spaces`, 34, all SUCCESS, 30d retention) provide the
  durable offsite copy. Both repos cover the same indices.
- Local 7d retention at 5h cadence = ~34 snapshots expected; 41 present
  (retention prunes by age, ok).

## Recommendation

1. **Keep local retention at 7 days** - it is a reasonable fast-recovery tier and
   uses 12G. No change required now (disk at 63%).
2. **If disk pressure returns** (>= 85%): reduce local KEEP to 3 days (~5G saved)
   BEFORE touching S3 (S3 is the durable DR tier).
3. **No deletion performed in Phase 9** - snapshots are the DR safety net and all
   states are SUCCESS.

## Restore/rollback impact note

- Restoring a local snapshot: `_snapshot/wazuh-backup/<name>/_restore` (fast, same host).
- Restoring an S3 snapshot: `_snapshot/do-spaces/<name>/_restore` (needs indexer
  S3 access - verified working via keystore creds).
- Both restore paths tested-capable; full DR restore test pending on VM 203
  (Phase 9.11 follow-up / Phase 10).

## No secrets

No secret values printed.
