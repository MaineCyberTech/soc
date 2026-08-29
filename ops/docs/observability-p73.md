# Phase 73 Observability — Adopted Schema & Migration Policy

## OpenTelemetry messaging semantic conventions (pinned)
Phase 73 adopts the OpenTelemetry **Messaging** semantic conventions for the delivery
pipeline. The upstream "Messaging" conventions are currently marked **Development**; to
avoid silent breakage, Phase 73 pins the adopted attribute set and a migration policy:

- **Pinned attribute set (Phase 73):**
  - `messaging.system` = `shuffle`
  - `messaging.destination.name` = `iris-alerts`
  - `messaging.operation` ∈ {`deliver`, `retry`, `replay`, `reconcile`}
  - `messaging.message.id` = Wazuh event id (stable idempotency key)
  - `messaging.client.id` = `shuffle-backend`
- **Span taxonomy (derived from the Shuffle workflow execution timeline):**
  - `delivery_span` — workflow execution start → IRIS POST `ROUTED` (or `DEAD_LETTER`).
  - `retry_span` — each retry attempt within the delivery span (from `attempt` field).
  - `replay_span` — operator-approved replay execution (from `REPLAY_APPROVED`).
  - `reconciliation_span` — ambiguous destination acceptance → `RECONCILIATION_REQUIRED`.
- **Migration policy:** if/when the upstream OTel Messaging convention graduates from
  Development, re-map only added/renamed attributes; never change `messaging.message.id`
  (the idempotency key) or drop `messaging.operation` values, to preserve correlation.
- **Payload minimization & cardinality bounding:** spans/metrics carry only the stable
  message id, operation, status, and attempt count — **never** raw event content or
  credentials. Tag cardinality is bounded by source classification (e.g., `class:A`), not
  per-event raw fields.

## SLO & burn-rate (implemented)
- **SLO:** delivery success ratio ≥ 99% over a 28-day window.
- **Burn-rate alerts (live):** fast burn = 14.4× over 1h; slow burn = 6× over 6h.
  Implemented by `ops/scripts/p73-burn-rate.py` against the dedup ledger; exits non-zero
  when breaching so it can drive an alert.
- **Residual platform gap:** a dedicated OpenTelemetry collector/exporter is NOT deployed;
  spans are currently derived from the Shuffle execution timeline and the burn-rate is
  computed from the dedup ledger. The schema, SLO, and burn-rate logic are live; emitting
  them via a collector is a platform addition (tracked, not blocking).
