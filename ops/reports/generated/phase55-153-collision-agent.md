# Phase 55: Agent Collision — distinct

**Report ID:** phase55-153-collision-agent
**Phase:** 55
**Title:** Agent Collision — distinct
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:30:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** /home/user/mct-p55/prompts/153-collision-agent.md
**Prompt:** 153-collision-agent
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** PARTIAL

## Summary
DEFECT/GAP: the workflow reads no agent/sensor identifier at all, and the dedup key does not include one. Two events from distinct agents/sensors but sharing (sid,src,dst,port) collapse to a single DUPLICATE. Agent collisions are not distinguished or attributed.

## Evidence
- EV-L2 (VERIFIED): live workflow `e133a645-95b9-4e01-9454-e270d2a0b599` code inspected; guarded `deadletter()`/`notify()` writes (try/except, never raises) present for the failure set {AUTH_FAILED,TARGET_FAILED,DATASTORE_READ_FAIL,COUNTER_FAIL,UNKNOWN}.

## Backup / Rollback
No production changes made. Live read-only inspection only. The isolated synthetic replay events fired (ENV_PROBE, DATASTORE_READ_FAIL, UNKNOWN, MALFORMED) write only to the Shuffle p53_* cache namespace (dead-letter/notification) and create NO IRIS case and NO production counter increment; they are bounded and persist in Shuffle's own backend (rollback = delete those cache keys by category). TARGET_FAILED/COUNTER_FAIL live re-injection was deliberately withheld to avoid inflating the internal p53_packet_routed counter. ROUTED live re-injection (MCT_SYNTHETIC:False) was withheld to avoid creating a new production IRIS object. No docker secret, compose, or service was modified.

## Stop conditions
Production-isolation guardrail: synthetic events kept isolated from production counters/cases; no MCT_SYNTHETIC:False ROUTED injection (no new IRIS object); no AUTH_FAILED/TARGET_FAILED/COUNTER_FAIL live replay that would contact IRIS or inflate the internal routed counter. Cache/state durability across restart requires a service restart (gate). No secret value was read, printed, or rotated.

## Limitations
- FND-2: no agent field is parsed; dedup key lacks agent → agent-different events unhandled.
- Live re-exercise gated at production routing; defect identified by code inspection.

## Verdict rationale
PARTIAL: agent collision is NOT handled — a real gap. Flagged as a limitation/defect (parse agent/sensor id and include in dedup key).
