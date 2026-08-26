# Phase 13 Canarytoken T1 Validation

Date: 2026-08-16
Status: BLOCKED - no hosted canarytokens.org account

## Blocker (unchanged from P12)

- Token T1 (fake-admin-url) requires a hosted canarytokens.org account.
- No account has been supplied by the operator.

## Validated deception assets (without hosted tokens)

- OpenCanary VM 202 (.241): active, rules 121007/121014 firing.
- Local OpenCanary: active, rule 121012 firing.
- Shuffle webhook routing: HTTP 200 (P11 execution afd4de3c).
- Wazuh alert->IRIS case path validated in earlier phases.

## Ready on account availability

1. Create hosted account -> token T1 (fake-admin-url).
2. Trigger safe lab test.
3. Validate chain: canarytokens -> Shuffle webhook -> IRIS case.
4. Document FPs + lifecycle (integrations/opencanary/phase9-canarytoken-t1-lifecycle.md).

## No secrets

No secret values printed.
