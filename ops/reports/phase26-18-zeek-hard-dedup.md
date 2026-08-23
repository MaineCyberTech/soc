# Phase 26 Zeek Hard Deduplication

Date: 2026-08-23
Status: **DESIGN READY - WORKFLOW-UI STEP PENDING** (datastore node requires the Shuffle editor; API catalog unavailable).

## Dedup design (datastore/cache-based)

- Key: `zeek-classa-dedup:<rule.id>:<src>:<dst>:<1h-bucket>`
- TTL: 1 hour (Shuffle datastore TTL).
- Branch: on GET-hit -> drop (duplicate, no IRIS post); on miss -> SET key + proceed to IRIS.

## Interim (implemented now)

- The stack guardrail (`zeek-classa-guardrail.sh`) rate-limits (24h count) and kills the route;
  per-event dedup at ingest requires the datastore node above (Shuffle workflow editor UI -
  add node between trigger and IRIS action).
- Replay behavior documented: current workflow posts per webhook (NOT idempotent); the replay
  test (20) records this honestly; the datastore node closes the gap.

## Note

- Shuffle Tools app action catalog not retrievable via API (app/actions endpoints empty/404),
  so the node must be added in the workflow UI (exact node design provided above).

## No secrets