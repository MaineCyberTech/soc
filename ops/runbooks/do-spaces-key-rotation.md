# DO Spaces Key Rotation Runbook

## When

- Operator provides new DO Spaces keys (or confirms current pair matches the
  indexer keystore creds).

## Steps

1. Update ops/creds.env:
   - DO_SPACES_ACCESS_KEY=<new>
   - DO_SPACES_SECRET_KEY=<new>
   (preserve 0600 perms)
2. Validate non-destructive:
   ```bash
   s3cmd --host="$DO_SPACES_ENDPOINT" --host-bucket="%(bucket)s.nyc3.digitaloceanspaces.com" \
     --access_key="$DO_SPACES_ACCESS_KEY" --secret_key="$DO_SPACES_SECRET_KEY" ls s3://wazuh/
   ```
   Expect a bucket listing (ListBucketResult), NOT an auth error.
3. Run the DR bundle:
   ```bash
   sudo bash /opt/wazuh-docker/multi-node/ops/scripts/dr-s3-bundle.sh
   ```
4. Verify s3://wazuh/dr/current/ + s3://wazuh/dr/history/ updated.
5. Run credential-rotation-validation.sh --check-all (expect PASS).
6. Update phase10-p1-credential-rotation-status.md (status only).

## Safety

- One credential at a time; validate before revoke.
- Never print values in logs/reports.
- The indexer keystore keys must remain (they power S3 snapshots); creds.env keys
  are for CLI/dr-s3 bundle use only.

## No secrets

No secret values printed.
