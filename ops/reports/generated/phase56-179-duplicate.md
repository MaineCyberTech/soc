# Phase 56: DUPLICATE (correct key)

**Prompt:** 179-duplicate
**Generated (UTC):** 2026-08-28T00:25:00Z
**Operator (EDT):** 2026-08-27T20:25:00-0400
**Verdict:** PARTIAL

## Summary
The DUPLICATE branch EXISTS and is VERIFIED, but the dedup KEY is DEFECTIVE: `p53_dedup_%s_%s_%s_%s` (sid,src,dst,port) OMITS `proto` and `agent`, so distinct-protocol/agent events are falsely collapsed (Phase 55 DUPLICATE defect). The branch was observed live (18 DUPLICATE in last 100). The 'correct key' requirement (proto+agent + governed observer identity) is NOT yet met — fix is gated edit 122.

## Evidence
EV-179-1 (VERIFIED): Source lines ~119-130 — dedup via `check_cache_contains(append=True)`; duplicate returns `emit("DUPLICATE")`. Branch present.
EV-179-2 (VERIFIED): Dedup key line ~120 OMITS `proto`+`agent` → false collapse (Phase 55 defect carried forward).
EV-179-3 (VERIFIED): 18 DUPLICATE results in last 100 executions confirm branch live (but with defective key).

## Backup / Rollback
No mutation. Dedup-key fix (122) reverts via workflow revision (gate 057-061).

## Stop conditions
Dedup-fix edit (122) is owner-gated; not performed here — 'correct key' requirement unmet.

## Limitations
None.

## Verdict rationale
PARTIAL: DUPLICATE branch VERIFIED present and live, but the dedup key is defective (missing proto/agent); 'correct key' requires the gated fix (122).
