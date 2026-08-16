# Phase 10 P1 Credential Rotation Status

Date: 2026-08-15

## P1 items (names/lengths only)

| Credential | Stored | Status |
|---|---|---|
| DO Spaces access key | present (20 chars) | **STALE for CLI** (403; snapshots fine via keystore) |
| DO Spaces secret key | present (91 chars) | STALE (same 403) |
| WAZUH_ADMIN_PASSWORD | present (9 chars) | WORKING (indexer 200) |
| Cloudflare tunnel token | present (.env.cloudflare) | WORKING (container Up) |

## Rotation decision

- **NO rotation performed**: operator has NOT supplied new protected values.
- Blockers: DO Spaces keys - no new values; WAZUH_ADMIN_PASSWORD - no new value;
  Cloudflare token - no new value.
- All three dependents validated working (indexer, S3 snapshots, tunnel).

## Dependent validation (2026-08-15)

- Indexer via admin creds: 200.
- S3 snapshot repo (keystore): 35 snapshots SUCCESS.
- Cloudflare tunnel: container Up.
- dr-s3 CLI bundle: 403 (DO keys stale - accepted local-only, P10.02).

## Required operator action

1. Provide NEW DO Spaces keys -> update creds.env -> re-run dr-s3-bundle.sh.
2. Provide new values for WAZUH_ADMIN_PASSWORD / Cloudflare token to rotate
   (one at a time, validate before revoke).

## No secrets

No secret values printed.
