# Phase 23 Client Fleet Billing and Scorecard Readiness

Date: 2026-08-22

## Endpoint-by-endpoint

| id | Status | Telemetry | Quality | Billable | Coverage | Owner action |
|---|---|---|---|---|---|---|
| 013 SAMSUNG | offline 6d | none | n/a | billable - NOT covered | gap 6d | client power confirm |
| 014 DESKTOP-MI54LFT | active | EID7 flood throttled | DEGRADED | billable - covered, noisy | throttle hides signal | operator tuning apply (blocked) |
| 015 Julians-Air | **active (reconnected 04:22)** | bounded ULS flowing | **HEALTHY (validating)** | billable - covered | 24h window accruing | none (re-verify post-upgrade) |

## Billing readiness

- **PARTIAL**: 015 restored -> 2/3 covered (014 noisy, 013 offline). Still NOT fully ready
  (policy: healthy telemetry per endpoint). Invoice gated until 013 confirmed + 014 tuned.
  See `service-packaging/phase23-billing-readiness.md`.

## Scorecard readiness

- 015 can enter scorecard after 24h window (00:00 UTC 08-23).
- 014 metrics suppressed by throttle - exclude until tuned.
- 013 excluded until confirmed.
- Progress: `reporting/output/client/phase23-scorecard-progress.md` (moved to internal/ per
  client-artifact governance).

## No secrets