# Phase 27 Shuffle Datastore Dedup

Date: 2026-08-24
Status: **DESIGN SPECIFIED - UI/EDITOR IMPLEMENTATION REQUIRED** (API surface does not
support node/catalog edits; verified conditions are stripped on update).

## Implementation spec (Shuffle workflow editor)

1. Add node: Shuffle Tools -> Datastore GET (key lookup).
2. Add node: Shuffle Tools -> Datastore SET (write + TTL 1h).
3. Key: `zeek-classa-dedup:<rule.id>:<src>:<dst>:<1h-bucket>` (normalized lowercase).
4. Branch logic: GET hit -> duplicate branch (drop, log metric); GET miss -> SET (TTL 1h) ->
   proceed to IRIS action.
5. Failure behavior: datastore error -> fail-open (route to IRIS) OR fail-closed (drop +
   notify) - decision: fail-open with metric (availability over dedup, guardrail backstop).

## Interim (in force)

- Cron guardrail (`zeek-classa-guardrail.sh`) rate-limits 5/day + kill switch (proven).
- Replay test (20) documents current non-idempotency until the node lands.

## No secrets