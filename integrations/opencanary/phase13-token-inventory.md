# Phase 13 Canarytoken Token Inventory

Date: 2026-08-16
Status: T1 PENDING (hosted account blocked)

| # | Token | Type | Status | Placement | Owner |
|---|---|---|---|---|---|
| T1 | fake-admin-url | URL/document | PENDING - account blocked | lab/internal (approved) | MCT SOC |
| T2 | fake-credential-file | document | PLANNED | - | MCT SOC |
| T3 | fake-db-creds | document | PLANNED | - | MCT SOC |

## Validated assets

- OpenCanary VM 202 + local: active, rules firing.
- Shuffle->IRIS path: validated (HTTP 200).

## Rules

- No real credentials in tokens.
- FPs: notify-only, document in IRIS case.

## No secrets
