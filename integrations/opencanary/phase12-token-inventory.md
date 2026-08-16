# Phase 12 Canarytoken Token Inventory

Date: 2026-08-16
Status: T1 PENDING (hosted account blocked); OpenCanary assets validated

| # | Token | Type | Service | Status | Placement | Owner |
|---|---|---|---|---|---|---|
| T1 | fake-admin-url | URL/document | canarytokens.org (hosted) | **PENDING - account blocked (P12.13)** | lab/internal (approved) | MCT SOC |
| T2 | fake-credential-file | document | hosted | PLANNED | - | MCT SOC |
| T3 | fake-db-creds | document | hosted | PLANNED | - | MCT SOC |

## Validated deception assets (no hosted account needed)

- OpenCanary VM 202 (.241) - active, 121007/121014 firing
- Local OpenCanary - active, 121012 firing
- Shuffle webhook path - re-validated P11 (HTTP 200)

## Rules

- No real credentials in any token.
- Lifecycle: integrations/opencanary/phase9-canarytoken-t1-lifecycle.md
- FPs: notify-only, document in IRIS case.

## No secrets

No secret values printed.
