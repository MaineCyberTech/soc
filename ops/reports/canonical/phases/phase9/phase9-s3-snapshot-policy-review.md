# Phase 9 S3 Snapshot Policy Review

Date: 2026-08-15
Scope: DO Spaces bucket `wazuh` - OpenSearch snapshots (repo `do-spaces`) + DR config bundle

## Inventory (evidence without secrets)

| Item | Value |
|---|---|
| S3 snapshots | 34 (2026-08-09 06:48 -> 2026-08-15 15:47) |
| All states | SUCCESS |
| Retention (configured) | 30 days (KEEP=30 in elastic-snapshot-s3.sh) |
| Frequency | every 5h (cron 47 */5) |
| Repo config | bucket wazuh, endpoint nyc3.digitaloceanspaces.com, base_path wazuh-snapshots |
| Credentials | indexer keystore (NOT in creds.env - this is why shell tools get 403) |

## DR config bundle (dr-s3-bundle.sh) - BROKEN

- Syncs configs/certs/creds/plugin/maxmind/guide to s3://wazuh/dr/
- **Fails with 403 SignatureDoesNotMatch** (uses DO_SPACES_* from creds.env,
  which are stale/invalid for this bucket).
- Local staging still produced daily at /opt/wazuh-backups/dr-stage (88M),
  config bundle config-20260815-040001.tar.gz present.
- S3 snapshots themselves work because the indexer uses its own keystore creds.

## Policy recommendation

1. **S3 snapshot tier**: keep 30d retention - it is the durable DR layer; no change.
2. **DR config bundle**: FIX REQUIRED - obtain valid DO Spaces keys (matching the
   indexer keystore creds that successfully write to bucket wazuh) and update
   creds.env; re-test dr-s3-bundle.sh. Until fixed:
   - config DR is LOCAL-ONLY (dr-stage 88M) - acceptable short-term (configs are
     also in git/backups), but the S3 DR story is incomplete.
   - Record as open risk in Phase 9 final report.
3. **S3-only option**: if local disk pressure returns, S3 (34 snapshots, 30d) can
   substitute for local (7d) as primary DR - the snapshots are verified SUCCESS.

## Dependency risk

- S3 upload depends on: indexer keystore creds (working), network to
  nyc3.digitaloceanspaces.com, bucket permission (wazuh, path wazuh-snapshots).
- dr-s3-bundle depends on creds.env keys - currently BROKEN (see above).
- Verification cadence: snapshot-s3-cron.log checked by freshness check (< 48h) -
  currently OK.

## No secrets

No secret values printed.
