# Phase 25 Zeek Case Validation

Date: 2026-08-22
Status: **WINDOW OPEN** (since enable 07:15 UTC 2026-08-22).

## Measurement plan (24h after enable)

| Metric | Target |
|---|---|
| Shuffle executions | <= 10 |
| IRIS cases | <= 5 (Class A only) |
| Duplicates (dedup) | 0 |
| Replay artifacts | 0 (idempotency) |
| False positives | reviewed per case |
| Stop threshold | > 5 cases/day -> kill switch + notify |

## Evidence

- Case list + dedup log + execution log recorded once window opens.

## No secrets
## Initial window readings (first hours)

- Shuffle executions: 2 synthetic test executions (FINISHED, notify-only) - 0 from real alerts.
- IRIS cases: 0 (real). Class A alerts are rare (~1/day) - window will accrue over days.
- Dedup/rate-limit: operator-monitored threshold (5/day) in effect; hard automation Phase 26.
