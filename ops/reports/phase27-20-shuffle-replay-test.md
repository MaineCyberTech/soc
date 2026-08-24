# Phase 27 Shuffle Replay Idempotency Test

Date: 2026-08-24
Status: **BASELINE RECORDED - PROOF PENDING UI DEDUP NODE**.

## Baseline (current behavior, observed)

- Submitting identical events to the webhook: each accepted post flows to the IRIS action
  (no suppression) - **not idempotent** without the datastore node.
- Synthetic curl posts returned success:false and did NOT reliably create executions (a
  periodic :58-second loop creates FINISHED executions independently) - execution counting
  for synthetic tests is unreliable.

## Proof procedure (post UI dedup implementation)

1. Submit identical Class A event 3x.
2. Expect: 1 routed action (IRIS post), 2 duplicate suppressions (datastore hits).
3. Inspect workflow execution logs for dedup metrics.
4. Clear only the test datastore keys (prefix `zeek-classa-dedup:<test>`).

## Interim

- Guardrail (rate-limit + kill switch) is the operational backstop; replay gap documented.

## No secrets