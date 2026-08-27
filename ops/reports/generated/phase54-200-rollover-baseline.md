# Phase 54: Rollover Baseline

**Prompt:** 200-rollover-baseline
**Generated (UTC):** 2026-08-27T21:29:01Z
**Operator (EDT):** 2026-08-27T17:29:01-0400
**Verdict:** DONE

## Summary
Establish the current baseline for rollover failure state, index growth, and cluster health. Read-only evidence collected; no mutation performed.

## Evidence
- E1 — `date -u` / `TZ=America/New_York date`: UTC 2026-08-27T21:29:01Z, EDT 2026-08-27T17:29:01.
- E2 — `_cluster/health`: status yellow, 1 node, 76 active primary+replica shards, 64 unassigned (expected for single-node with replica=1).
- E3 — `_cat/indices`: workflowexecution-000001 = 1173 docs / 32.4mb; organizations = 1 doc / 839kb; hooks = 6 docs / 70kb; workflow-000001 = 3 docs / 1.9mb.
- E4 — ISM `explain/workflowexecution-000001`: policy shuffle-rollover attached, state "hot", rollover action `failed:true`, `rolled_over:false`, `enabled:false`.
- E5 — ISM policy shuffle-rollover: rollover action min_size 40gb / min_doc_count 1000000 / min_index_age 90d / copy_alias false; only state "hot"; error_notification null.

## Backup / Rollback
N/A (read-only baseline).

## Stop conditions
None.

## Limitations
Growth rate over time not captured (point-in-time baseline only); sustained rate requires ongoing monitoring (see 206).

## Verdict rationale
Baseline captured with real cluster/index/ISM evidence. Rollover is INERT (failing, not retrying). No action needed beyond monitoring.
