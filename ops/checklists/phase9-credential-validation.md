# Phase 9 Credential Validation Checklist

Date: 2026-08-15
Usage: run credential-rotation-validation.sh after ANY rotation; never print values.

## Before rotation

- [ ] Operator supplied NEW protected value (from secure channel)
- [ ] Back up current value location (creds.env is in git-ignored ops/)
- [ ] Identify all dependents (scripts, cron, containers) for the credential

## During rotation (one credential at a time)

- [ ] Update ops/creds.env (or .env.cloudflare / /opt/mct-security-stack/.env)
- [ ] Restart the dependent service/container
- [ ] Run `credential-rotation-validation.sh --check-all` (expect PASS)

## After rotation

- [ ] Validate real workflow (e.g., dr-s3-bundle.sh produces SUCCESS; snapshot
      repo works)
- [ ] Revoke the OLD value (operator action at the provider)
- [ ] Record status in phase9-p1-credential-rotation.md (names only)

## Known validation gaps (Phase 9)

- DO Spaces check accepts any endpoint response -> fix to require
  `ListBucketResult` XML (auth errors return `Error`/`AccessDenied`).
- S3 snapshot repo validated via indexer keystore, not creds.env keys.

## No secrets

No secret values printed.
