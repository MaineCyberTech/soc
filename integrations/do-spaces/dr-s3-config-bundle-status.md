# DR S3 Config Bundle Status

Date: 2026-08-15

## Status: DEGRADED - local-only accepted (fix blocked on new keys)

| Item | Value |
|---|---|
| Script | ops/scripts/dr-s3-bundle.sh |
| Cron | 0 4 * * * (daily 04:00) |
| Log | /opt/wazuh-backups/dr-s3-cron.log |
| Last result | **403 SignatureDoesNotMatch** (creds.env keys stale) |
| Local staging | /opt/wazuh-backups/dr-stage (fresh daily) |
| S3 snapshots | WORKING (indexer keystore, 35) |
| Blocker | No new DO Spaces values supplied; keystore keys not retrievable |

## Impact

- Config/cert DR is local-only for the pilot term.
- Data DR unaffected (S3 snapshots healthy).
- First client launch condition: fix-or-accept -> ACCEPTED for pilot.

## Resolution path

1. Operator provides valid DO Spaces keys -> update ops/creds.env.
2. Re-run dr-s3-bundle.sh (see do-spaces-key-rotation.md).
3. Verify s3://wazuh/dr/current + history.

## No secrets

No secret values printed.
