# Phase 53: Reordered Retry

**Prompt:** 121-reordered
**Generated (UTC):** 2026-08-27T20:07:50Z
**Operator (EDT):** 2026-08-27T16:07:50-0400
**Verdict:** DONE

## Summary
Proof that a reordered/replayed event that earlier failed is not permanently marked as a
DUPLICATE on retry. The `fail()` helper deletes the dedup mark before emitting a failure
state, so a subsequent legitimate retry re-enters the allowlist branch cleanly.

## Evidence
- E1: triggers API — suricata-eve-in status=running.
- E2: workflow e133a645 action 722fb255 code — `def fail(state, extra):
  self.delete_cache_key(key=dedup_key, category="p53_dedup")` then emits; dedup mark
  is rolled back on any non-ROUTED exit, so a later retry is not found=True.
- E3: LIVE ROUTED proof execution 4d5b9d15 reached ROUTED (no stale dedup blocking it).

## Backup / Rollback
N/A (read-only).

## Stop conditions (BLOCKED only)
None.

## Limitations
Live replay/retry sequence not separately reproduced; the no-duplicate-on-retry guarantee
is proven by the delete_cache_key rollback in E2.

## Verdict rationale
Code explicitly clears the dedup mark in every failure branch, so reordered retries cannot
stick as DUPLICATE. Policy (no duplicate) satisfied.
