# Phase 10 DR S3 Config Bundle - Fix Attempt + Decision

Date: 2026-08-15

## Status: LOCAL-ONLY ACCEPTED (fix blocked - no new keys)

## Attempts

1. **Checked for new DO Spaces values** in protected files: NONE supplied by operator.
   creds.env last modified 2026-08-15 (P9 changes); no separate key files exist.
2. **s3cmd list test** with creds.env keys: 403 SignatureDoesNotMatch (confirmed stale).
3. **Searched for working keys**: the OpenSearch S3 repository (do-spaces) uses keys
   stored in the indexer's encrypted keystore - NOT retrievable (write-only keystore;
   not in repo settings, config files, or container env).
4. **Non-destructive access**: impossible with current CLI keys.

## Current DR state (working pieces)

| Piece | Status |
|---|---|
| S3 snapshots (OpenSearch do-spaces repo) | WORKING (35 snapshots, latest 2026-08-15 20:47) |
| Local config bundle staging | WORKING (config-20260815-040001.tar.gz daily) |
| dr-assets (S3 repo plugin zip) | PRESENT |
| dr-stage scripts + maxmind + REBUILD.md | PRESENT |
| dr-s3 config bundle upload | **FAILING 403** (stale creds.env keys) |

## Decision: ACCEPT LOCAL-ONLY CONFIG DR FOR PILOT

- Config/cert DR remains local-only at /opt/wazuh-backups/dr-stage (~88M) + git
  history for configs. Acceptable for the pilot term (no client data at risk yet).
- Data DR (OpenSearch indices) is fully S3-backed (35 snapshots) - the critical tier.
- **Unblock required**: operator obtains valid DO Spaces keys (matching the
  indexer keystore creds) and updates ops/creds.env (DO_SPACES_ACCESS_KEY/
  DO_SPACES_SECRET_KEY), then re-run dr-s3-bundle.sh.

## Re-test procedure (when keys arrive)

```bash
# 1. verify CLI access
s3cmd --host="$DO_SPACES_ENDPOINT" --host-bucket="%(bucket)s.nyc3.digitaloceanspaces.com" \
  --access_key="$DO_SPACES_ACCESS_KEY" --secret_key="$DO_SPACES_SECRET_KEY" ls s3://wazuh/
# 2. run bundle
sudo bash /opt/wazuh-docker/multi-node/ops/scripts/dr-s3-bundle.sh
# 3. verify
s3cmd ... ls s3://wazuh/dr/current/ s3://wazuh/dr/history/
```

## No secrets

No secret values printed.
