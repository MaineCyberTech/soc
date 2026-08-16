# Canarytoken First Test (Phase 8)

## Steps (when hosted account exists)

1. canarytokens.org -> create document token (fake-backup-credentials.txt,
   placeholder content: "username: <REDACTED_FAKE> / password: <REDACTED_FAKE>").
2. Webhook: http://shuffle-frontend/api/v1/hooks/webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c
3. Record in canarytokens-inventory.md (placement, owner).
4. Place in controlled test location; touch it.
5. Confirm: Shuffle run -> IRIS alert (opencanary-hit, source:canarytokens).
6. Cleanup: remove artifact, note result.

## No real credentials

- Placeholder content only.
