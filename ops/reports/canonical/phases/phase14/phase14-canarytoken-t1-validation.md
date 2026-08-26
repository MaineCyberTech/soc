# Phase 14 Canarytoken T1 Validation

Date: 2026-08-16
Status: BLOCKED - no hosted canarytokens.org account (unchanged from P12/P13)

## Blocker

- T1 (fake-admin-url) requires a hosted canarytokens.org account.
- No account supplied by operator.

## Validated deception assets

- OpenCanary VM 202 + local: active, rules 121007/121012/121014 firing.
- Shuffle webhook path: HTTP 200 (P11).

## Ready on account availability

1. Create hosted account -> T1 token.
2. Trigger safe lab test -> validate chain to IRIS.
3. Document FPs + lifecycle.

## No secrets
