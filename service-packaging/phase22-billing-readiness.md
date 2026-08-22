# Phase 22 Billing Readiness

Date: 2026-08-22
Status: **NOT READY** - billable fleet coverage is degraded.

## Billable endpoints (3)

| Endpoint | Status | Billing-readiness impact |
|---|---|---|
| 013 SAMSUNG | offline since 08-16 (power) | cannot attest coverage |
| 014 DESKTOP-MI54LFT | active + Sysmon EventID 7 noise | coverage OK but archive-noise must be tuned before clean reporting |
| 015 Julians-Air | disconnected since 08-18 (flood) | cannot attest coverage |

## Billing-readiness criteria (per `billing-endpoint-count-policy.md`)

- Billable count = 3 (013/014/015) - matches contract.
- Coverage attestation requires active agent + healthy telemetry on each endpoint:
  - 013: needs power/connectivity confirmation (client action).
  - 015: needs Mac-side flood fix (operator action) + reconnect + 24h validation.
  - 014: active; needs Sysmon EventID 7 tuning to stop archive flood and restore
    signal-to-noise before scorecard/quality numbers are shared.

## Recommendation

- Do not issue invoice/coverage attestation until fleet health restored (013, 015) and 014
  noise tuned. Interim: notify client of 013 power check + schedule 015 fix window.
- Scorecard cycle target 09-15 remains; fleet restoration is the gating item.

## No secrets