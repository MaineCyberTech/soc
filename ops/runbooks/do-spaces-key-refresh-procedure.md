# DO Spaces Key Refresh Procedure

Date: 2026-08-16

## When

- Operator provides new DO Spaces keys (or confirms current pair matches the
  indexer keystore creds).

## Steps

1. Update /opt/wazuh-docker/multi-node/ops/creds.env:
   - DO_SPACES_ACCESS_KEY=<new>
   - DO_SPACES_SECRET_KEY=<new>
   (preserve 0600 perms)
2. Validate non-destructive:
   ```bash
   s3cmd --host="$DO_SPACES_ENDPOINT" --host-bucket="%(bucket)s.nyc3.digitaloceanspaces.com" \
     --access_key="$DO_SPACES_ACCESS_KEY" --secret_key="$DO_SPACES_SECRET_KEY" ls s3://wazuh/
   ```
   Expect ListBucketResult (not an auth error).
3. Run the DR bundle:
   ```bash
   sudo bash /opt/wazuh-docker/multi-node/ops/scripts/dr-s3-bundle.sh
   ```
4. Verify s3://wazuh/dr/current/ + s3://wazuh/dr/history/ updated.
5. Run credential-rotation-validation.sh --check-all -> PASS.
6. Update ops/reports/phase11-dr-s3-resolution.md (status).

## Safety

- One credential at a time; validate before revoke.
- Indexer keystore keys must remain (they power S3 snapshots).
- Never print values.

## No secrets

No secret values printed.
