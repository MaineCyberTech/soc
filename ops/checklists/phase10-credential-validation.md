# Phase 10 Credential Validation Checklist

Date: 2026-08-15

## Before rotation
- [ ] Operator supplied NEW protected value (secure channel)
- [ ] Backup current value location (creds.env / .env.cloudflare)
- [ ] Identify dependents

## During (one at a time)
- [ ] Update the store
- [ ] Restart dependent service
- [ ] Run credential-rotation-validation.sh --check-all -> PASS

## After
- [ ] Validate real workflow (dr-s3 bundle SUCCESS, snapshots, tunnel)
- [ ] Operator revokes old value
- [ ] Update phase10-p1-credential-rotation-status.md

## Current state (2026-08-15)
- [x] No new values - all rotations DEFERRED
- [x] Wazuh admin / Cloudflare / S3 snapshots validated working
- [x] DO CLI keys stale (documented, P10.02)

## No secrets

No secret values printed.
