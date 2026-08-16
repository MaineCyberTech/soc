# Hosted Canarytokens - Phase 9 Status

Date: 2026-08-15
Service: canarytokens.org (hosted)

## Decision (Phase 8): hosted first

- Faster validation; self-hosted (canarytokens-docker on VM103) deferred unless
  client data residency requires it.

## Phase 9 state

| Item | Status |
|---|---|
| Service reachable | YES (200) |
| Account provisioned | NO (blocker: operator email/auth-token required) |
| Webhook destination (Shuffle) | VALIDATED (success:true, execution b24d020d) |
| T1 token created | PENDING (blocked on account) |
| IRIS alert path | Validated in Phase 8 via canary events; webhook path confirmed |

## Plan when account exists

1. canarytokens.org -> create document token T1 (fake-backup-credentials.txt,
   placeholder content only).
2. Webhook: http://192.168.222.149:3001/api/v1/hooks/webhook_d1e66f3f-... (Shuffle)
3. Record in canarytokens-inventory.md.
4. Place in controlled lab location; touch; verify Shuffle run -> IRIS.
5. Cleanup + lifecycle note.

## No secrets

No secret values printed.
