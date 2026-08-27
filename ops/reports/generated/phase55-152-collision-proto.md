# Phase 55: Protocol Collision — distinct

**Report ID:** phase55-152-collision-proto
**Phase:** 55
**Title:** Protocol Collision — distinct
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:30:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** /home/user/mct-p55/prompts/152-collision-proto.md
**Prompt:** 152-collision-proto
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** PARTIAL

## Summary
DEFECT/GAP: the dedup key is p53_dedup_{sid}_{src}_{dst}_{port} and does NOT include PROTO. Two events that are identical on (sid,src,dst,port) but differ only by protocol will share a dedup key; the second is marked DUPLICATE and suppressed, so a genuinely distinct protocol event is incorrectly collapsed. Protocol collisions are NOT distinguished.

## Evidence
- EV-L2 (VERIFIED): live workflow `e133a645-95b9-4e01-9454-e270d2a0b599` code inspected; guarded `deadletter()`/`notify()` writes (try/except, never raises) present for the failure set {AUTH_FAILED,TARGET_FAILED,DATASTORE_READ_FAIL,COUNTER_FAIL,UNKNOWN}.

## Backup / Rollback
No production changes made. Live read-only inspection only. The isolated synthetic replay events fired (ENV_PROBE, DATASTORE_READ_FAIL, UNKNOWN, MALFORMED) write only to the Shuffle p53_* cache namespace (dead-letter/notification) and create NO IRIS case and NO production counter increment; they are bounded and persist in Shuffle's own backend (rollback = delete those cache keys by category). TARGET_FAILED/COUNTER_FAIL live re-injection was deliberately withheld to avoid inflating the internal p53_packet_routed counter. ROUTED live re-injection (MCT_SYNTHETIC:False) was withheld to avoid creating a new production IRIS object. No docker secret, compose, or service was modified.

## Stop conditions
Production-isolation guardrail: synthetic events kept isolated from production counters/cases; no MCT_SYNTHETIC:False ROUTED injection (no new IRIS object); no AUTH_FAILED/TARGET_FAILED/COUNTER_FAIL live replay that would contact IRIS or inflate the internal routed counter. Cache/state durability across restart requires a service restart (gate). No secret value was read, printed, or rotated.

## Limitations
- FND-1: proto absent from dedup key → protocol-different events collide as DUPLICATE (false suppression).
- Live re-exercise gated at production routing; defect identified by code inspection.

## Verdict rationale
PARTIAL: protocol collision is NOT handled — a real gap. Flagged as a limitation/defect for owner remediation (extend dedup key to include proto).
