# Phase 18 Rule 120537 Noise Review

Date: 2026-08-17

## Before/After

| Metric | Before | After |
|---|---|---|
| Rule level | 5 | 3 |
| Volume | 2,548/24h | same (still logged, lower severity) |
| Alerting | level-5 alerts | level-3 (info) |

## Assessment

- Constant app-error loop (Redis DNS) - not actionable security signal.
- Kept at level 3 for operational visibility.
- Revert to 5 when Redis loop fixed.

## No secrets
