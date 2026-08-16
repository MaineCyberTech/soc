# S3 Snapshot Dependency Risk

Date: 2026-08-15

## Dependency chain

S3 snapshot SUCCESS requires ALL of:

1. **Indexer keystore credentials** - working (repo do-spaces uses them;
   snapshots SUCCESS).
2. **Network path** to nyc3.digitaloceanspaces.com from indexer containers.
3. **Bucket permissions** (bucket wazuh, path wazuh-snapshots).
4. **Cron** (47 */5, /etc/cron.d/wazuh-backups) + freshness check (< 48h).

## Known gaps / risks

| Risk | Status | Mitigation |
|---|---|---|
| dr-s3-bundle.sh 403 (config bundle to S3) | **OPEN** | Obtain valid DO keys; configs remain local-only in dr-stage (88M) + git |
| creds.env DO_SPACES_* stale | **OPEN** | Compare with indexer keystore creds; rotate + update creds.env |
| s3cmd CLI unusable for manual ops | OPEN (same keys) | Use indexer repo API for snapshot ops; fix keys for CLI |
| S3 access from non-indexer hosts unverified | OK (snapshots flow) | None needed |

## Impact assessment

- **Data DR (OpenSearch indices)**: HEALTHY - 34 S3 snapshots, all SUCCESS.
- **Config/cert DR to S3**: DEGRADED - local-only staging; restore would need
  manual upload or local copy. Acceptable short-term (configs also in
  ops/backups + git history), but should be fixed before first client launch
  (client configs would be part of future bundles).

## Decision record

- Phase 9: no deletion of S3 content; no change to snapshot retention.
- Action item: fix DO Spaces keys (priority: before first client launch).

## No secrets

No secret values printed.
