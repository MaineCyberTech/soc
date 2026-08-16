# Canarytokens Validation

Date: 2026-08-11
Status: **BLOCKED - no canarytokens service provisioned**

## Acceptance criteria check

- Inventory exists: YES (integrations/opencanary/canarytokens-inventory.md + canarytokens-deployed.md)
- No real secrets used: CONFIRMED (placeholder policy)
- At least one token test passes OR blocker documented: BLOCKER DOCUMENTED
  (hosted canarytokens requires account/approval; self-hosted requires VM build)

## Blocker

1. No canarytokens service (hosted or self-hosted) is provisioned.
2. Token webhook needs a Shuffle trigger (Phase 5.16 webhook map - pending).
3. Placement requires operator + client authorization.

## When tokens are deployed

1. Create token with webhook -> Shuffle.
2. Place one test token (T1 fake-backup-credentials.txt) in a controlled location.
3. Touch it from a test account; confirm webhook -> Shuffle -> IRIS.
4. Record result + cleanup.
