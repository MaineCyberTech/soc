# Phase 54: Reordered Retry

**Prompt:** 126-reorder
**Generated (UTC):** 2026-08-27T21:28:32Z
**Operator (EDT):** 2026-08-27T17:28:32-0400
**Verdict:** DONE

## Summary
Ensure a reordered/retry of the same event does not create a duplicate delivery, while a genuine
replay is still caught. The `fail()` helper deletes the dedup mark on any failure path (lines
132-138), so a failed/aborted attempt is rolled back and a later retry proceeds fresh rather than
being permanently DUPLICATE. A true replay (mark already present) returns DUPLICATE (line 130).

## Evidence
- E1 — `/tmp/opencode/pkt_code.py` lines 129-130: `found=True` → emit DUPLICATE (genuine replay).
- E2 — lines 132-138: `fail()` deletes `dedup_key` so a failed attempt is not permanently duplicate.
- E3 — `check_cache_contains(..., append=True)` marks on first call, `found=True` on repeats (line 124).

## Backup / Rollback
Read-only; N/A.

## Stop conditions
None.

## Limitations
Behavior verified from code; live reorder test not sent (no production/synthetic packet needed by
this analysis prompt; LIVE-TEST bound not exercised).

## Verdict rationale
Reordered retries are not wrongly deduped and genuine duplicates are caught.
