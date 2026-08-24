# Phase 27 Shuffle Daily Rate Limit

Date: 2026-08-24
Status: **CRON GUARDRAIL ACTIVE; WORKFLOW-NATIVE COUNTER = UI SPEC**.

## Workflow-native spec (editor)

1. Datastore counter key `zeek-classa-count:<yyyymmdd>` (increment per routed event).
2. Threshold branch: count >= 5 -> notification node + route suppression (skip IRIS).
3. Midnight reset via TTL/date-key.

## In force now

- `zeek-classa-guardrail.sh` (cron */15): 24h execution count; >= 5 -> kill switch (comments
  integration + container restart) + state log. Manual enable/disable.
- Under-limit today: 4 executions; integration enabled.

## No secrets