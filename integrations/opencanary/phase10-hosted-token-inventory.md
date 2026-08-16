# Phase 10 Hosted Token Inventory

Date: 2026-08-15

| # | Token | Type | Service | Status | Placement | Owner |
|---|---|---|---|---|---|---|
| T1 | fake-admin-url | URL/document | canarytokens.org (hosted) | **PENDING (account blocked)** | lab/internal (approved) | MCT SOC |
| T2 | (future) fake-credential-file | document | hosted | PLANNED | - | MCT SOC |
| T3 | (future) fake-db-creds | document | hosted | PLANNED | - | MCT SOC |

## Existing deception assets (validated)

- OpenCanary VM 202 (.241): active, rule 121007/121014 firing.
- Local OpenCanary: active, rule 121012 firing (restored P10).

## Rules

- No real credentials in any token.
- Token lifecycle per phase9-canarytoken-t1-lifecycle.md.
- False positives: notify-only; document in IRIS case.

## No secrets

No secret values printed.
