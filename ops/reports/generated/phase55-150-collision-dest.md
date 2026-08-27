# Phase 55: Destination Collision — distinct

**Report ID:** phase55-150-collision-dest
**Phase:** 55
**Title:** Destination Collision — distinct
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:30:00Z
**Classification:** INTERNAL
**Status:** DONE
**Source Path:** /home/user/mct-p55/prompts/150-collision-dest.md
**Prompt:** 150-collision-dest
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** DONE

## Summary
Dedup key includes DST_IP, so two events differing only by destination are distinct (no collision). Verified by code inspection (EV-L2).

## Evidence
- EV-L2 (VERIFIED): live workflow `e133a645-95b9-4e01-9454-e270d2a0b599` code inspected; guarded `deadletter()`/`notify()` writes (try/except, never raises) present for the failure set {AUTH_FAILED,TARGET_FAILED,DATASTORE_READ_FAIL,COUNTER_FAIL,UNKNOWN}.

## Backup / Rollback
No production changes made. Live read-only inspection only. The isolated synthetic replay events fired (ENV_PROBE, DATASTORE_READ_FAIL, UNKNOWN, MALFORMED) write only to the Shuffle p53_* cache namespace (dead-letter/notification) and create NO IRIS case and NO production counter increment; they are bounded and persist in Shuffle's own backend (rollback = delete those cache keys by category). TARGET_FAILED/COUNTER_FAIL live re-injection was deliberately withheld to avoid inflating the internal p53_packet_routed counter. ROUTED live re-injection (MCT_SYNTHETIC:False) was withheld to avoid creating a new production IRIS object. No docker secret, compose, or service was modified.

## Stop conditions
Production-isolation guardrail: synthetic events kept isolated from production counters/cases; no MCT_SYNTHETIC:False ROUTED injection (no new IRIS object); no AUTH_FAILED/TARGET_FAILED/COUNTER_FAIL live replay that would contact IRIS or inflate the internal routed counter. Cache/state durability across restart requires a service restart (gate). No secret value was read, printed, or rotated.

## Limitations
- Live re-exercise gated at production routing (synthetic path short-circuits before dedup).

## Verdict rationale
Destination collision correctly avoided: dst is in the dedup key. DONE (code-verified).
