# Canarytoken First Test (procedure)

## When service exists

1. Create token (canarytokens.org or self-hosted) with webhook:
   http://shuffle-frontend/api/v1/hooks/webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c
2. Place T1 fake-backup-credentials.txt (placeholder content only).
3. Record in canarytokens-inventory.md.
4. Touch the file -> expect webhook -> Shuffle run -> IRIS alert.
5. Cleanup: remove artifact, note result.

## Status

NOT EXECUTED - no canarytokens service (2026-08-12).
