# Phase 22 Client Fleet Billing and Scorecard Readiness

Date: 2026-08-22

## Endpoint-by-endpoint assessment

| id | Power/Agent | Telemetry quality | Billable state | Coverage gap |
|---|---|---|---|---|
| 013 SAMSUNG | offline 6d (power, unconfirmed remotely) | none | billable - NOT covered | FIM/SCA/Sysmon absent since 08-16 |
| 014 DESKTOP-MI54LFT | active (keepalive fresh) | **DEGRADED** - EID7 flood agent-side, rule-11 throttle, 13 buffer events/24h | billable - covered but noisy | signal suppressed by throttle; tuning blocked |
| 015 Julians-Air | offline 4d (flood, fix blocked on Mac access) | none | billable - NOT covered | unified-log flood unresolved |

## Billing readiness

- **NOT READY** (same as P21): 2/3 endpoints uncovered; 1/3 covered but degraded.
- Policy (`billing-endpoint-count-policy.md`) requires active agent + healthy telemetry per
  endpoint for coverage attestation. 013/015 fail active; 014 fails quality.
- **No invoice/coverage attestation** until: 013 power confirmed, 015 repaired + validated,
  014 tuned + validated (see `service-packaging/phase22-billing-readiness.md`).

## Scorecard readiness

- Scorecard numbers cannot be clean while: 014 throttle suppresses signal and 013/015 offline.
- Zeek noise fixed (v2.2) - alert quality metric now measurable for packet signal.
- Progress: `reporting/output/client/phase22-scorecard-progress.md` (cycle target 09-15).

## No secrets