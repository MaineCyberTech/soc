# Phase 12 Canarytoken T1 Validation

Date: 2026-08-16
Status: BLOCKED - no hosted canarytokens.org account

## Blocker

- Token T1 (fake-admin-url, URL/document type) requires a hosted
  canarytokens.org account. No account exists/operator not yet supplied one.
- No token can be created, triggered, or validated without the account.

## What IS validated (deception coverage without hosted tokens)

- OpenCanary VM 202 (.241): active, rules 121007/121014 firing (lab).
- Local OpenCanary: active, rule 121012 firing (restored in P10).
- Shuffle webhook routing re-validated in P11 (execution afd4de3c, HTTP 200).

## Ready-to-execute procedure (on account availability)

1. Create account at hosted canarytokens.org.
2. Create token T1 (fake-admin-url) with MCT-owned canary token domain.
3. Trigger safe lab test (browse token URL from a lab VM).
4. Validate: canarytokens alert -> Shuffle webhook -> IRIS case created.
5. Document false positives + lifecycle (integrations/opencanary/phase9-canarytoken-t1-lifecycle.md).

## Inventory

- integrations/opencanary/phase10-hosted-token-inventory.md (T1 pending, T2/T3 planned)

## No secrets

No secret values printed.
