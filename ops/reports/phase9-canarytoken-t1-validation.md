# Phase 9 Canarytoken T1 Validation

Date: 2026-08-15
Target: T1 = fake admin URL / document token (hosted canarytokens.org)

## Status: PARTIALLY VALIDATED - routing confirmed, token creation BLOCKED on account

## What was validated

1. **Canarytokens service reachability**: canarytokens.org returns 200.
2. **Shuffle webhook routing** (the token alert destination):
   - POST to http://127.0.0.1:3001/api/v1/hooks/webhook_d1e66f3f-c970-4817-8998-3610ad96e49f
     with safe payload -> **{"success": true, execution_id: b24d020d-...}** (HTTP 200)
   - Shuffle execution accepted; workflow triggers (opencanary-hit -> IRIS path
     validated in Phase 8 with real canary events).
3. Shuffle frontend healthy (200).

## Blocker (documented)

- Hosted token creation (canarytokens.org) requires an **account/email +
  auth-token**. No operator email/account is provisioned yet.
- Token generation endpoint returns 405 without valid auth_token.
- Per pack rules: no fake credentials embedded; placement requires operator
  approval anyway.

## Recommended unblock (operator action)

1. Operator creates canarytokens.org account (or supplies an email for the
   public create flow: canarytokens.org/generate with auth_token email).
2. Create T1 document token (fake-backup-credentials.txt with placeholder
   content) + webhook = Shuffle hook above.
3. Place in controlled test location; touch; confirm Shuffle execution + IRIS
   case; record in canarytokens-inventory.md.
4. Cleanup: remove artifact; document lifecycle.

## No secrets

No secret values printed. Webhook URL truncated.
