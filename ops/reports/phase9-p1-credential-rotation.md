# Phase 9 P1 Credential Rotation - Status

Date: 2026-08-15
Rule: rotate one credential at a time; validate before revoke; NEVER print values.

## P1 inventory (names/lengths only)

| Credential | Stored | Status |
|---|---|---|
| DO Spaces access key | present (20 chars) | **STALE for CLI/s3cmd use** (4x 403 SignatureDoesNotMatch in dr-s3-bundle) |
| DO Spaces secret key | present (91 chars) | STALE (same 403s) |
| WAZUH_ADMIN_PASSWORD | present (9 chars) | working (indexer green via admin) |
| Cloudflare tunnel token | present (.env.cloudflare) | working (tunnel container running) |

## Rotation decision

- **NO rotation performed in Phase 9**: the operator has not supplied NEW protected
  values. Per pack rules, rotation requires new values.
- Validated dependent systems still function with current values:
  - Wazuh indexer: PASS (green)
  - S3 snapshot repo (do-spaces via indexer keystore): PASS (34 snapshots)
  - Cloudflare tunnel: PASS (running)
  - IRIS / MISP / Shuffle API keys: PASS (validation script)

## DO Spaces discrepancy (IMPORTANT)

- dr-s3-bundle.sh (uses creds.env keys via s3cmd) -> **403 SignatureDoesNotMatch** (4 occurrences).
- S3 snapshots (via indexer keystore creds) -> SUCCESS.
- credential-rotation-validation.sh DO check is WEAK (accepts any endpoint
  response, including auth errors) -> reported PASS despite the 403s.
- Conclusion: the creds.env DO_SPACES_* pair is STALE. The indexer uses
  different (valid) keys in its keystore.
- Impact: dr-s3 config/cert bundle cannot upload to S3 (DR gap, see P9.03).

## Required operator action (P1)

1. Provide NEW DO Spaces keys (or confirm the current pair matches the indexer
   keystore) -> update ops/creds.env -> re-run dr-s3-bundle.sh -> verify upload.
2. Provide new values for any other P1 credential to rotate (one at a time,
   validate each before revoke).
3. Fix credential-rotation-validation.sh DO check to require a real ListBucketResult.

## No secrets

No secret values printed.
