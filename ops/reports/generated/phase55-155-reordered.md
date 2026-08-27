# Phase 55: Reordered Retry — no duplicate

**Report ID:** phase55-155-reordered
**Phase:** 55
**Title:** Reordered Retry — no duplicate
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:30:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** /home/user/mct-p55/prompts/155-reordered.md
**Prompt:** 155-reordered
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** PARTIAL

## Summary
Anti-replay behavior verified by code: a retried/reordered event with the same (sid,src,dst,port) hits an existing dedup key → found=True → DUPLICATE (suppressed, 'no duplicate' as intended). The dedup mark is rolled back only on failure states, so a successful route leaves the key and correctly suppresses replays.

## Evidence
- EV-L2 (VERIFIED): live workflow `e133a645-95b9-4e01-9454-e270d2a0b599` code inspected; guarded `deadletter()`/`notify()` writes (try/except, never raises) present for the failure set {AUTH_FAILED,TARGET_FAILED,DATASTORE_READ_FAIL,COUNTER_FAIL,UNKNOWN}.

## Backup / Rollback
No production changes made. Live read-only inspection only. The isolated synthetic replay events fired (ENV_PROBE, DATASTORE_READ_FAIL, UNKNOWN, MALFORMED) write only to the Shuffle p53_* cache namespace (dead-letter/notification) and create NO IRIS case and NO production counter increment; they are bounded and persist in Shuffle's own backend (rollback = delete those cache keys by category). TARGET_FAILED/COUNTER_FAIL live re-injection was deliberately withheld to avoid inflating the internal p53_packet_routed counter. ROUTED live re-injection (MCT_SYNTHETIC:False) was withheld to avoid creating a new production IRIS object. No docker secret, compose, or service was modified.

## Stop conditions
Production-isolation guardrail: synthetic events kept isolated from production counters/cases; no MCT_SYNTHETIC:False ROUTED injection (no new IRIS object); no AUTH_FAILED/TARGET_FAILED/COUNTER_FAIL live replay that would contact IRIS or inflate the internal routed counter. Cache/state durability across restart requires a service restart (gate). No secret value was read, printed, or rotated.

## Limitations
- Live re-exercise of a second identical real event would require non-synthetic routing (production) to reach the dedup branch; verified by code.
- Synthetic path short-circuits before dedup, so cannot be replayed in isolation.

## Verdict rationale
PARTIAL: reordered/retried events are correctly suppressed as DUPLICATE (fail-closed anti-replay). Live re-exercise gated at production routing; code-verified.
