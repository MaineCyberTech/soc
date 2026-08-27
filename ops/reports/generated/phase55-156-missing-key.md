# Phase 55: Missing Key — fail closed

**Report ID:** phase55-156-missing-key
**Phase:** 55
**Title:** Missing Key — fail closed
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:30:00Z
**Classification:** INTERNAL
**Status:** DONE
**Source Path:** /home/user/mct-p55/prompts/156-missing-key.md
**Prompt:** 156-missing-key
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** DONE

## Summary
Fail-closed verified live via isolated synthetic replay with no signature_id. Execution 9aeaf309 returned state MALFORMED (sid=null); the workflow returns before any IRIS post, dedup, or counter, so a missing key is safely dropped with no routing. (MALFORMED is not in the dead-letter failure set, so no dead-letter is written — acceptable: nothing was attempted.)

## Evidence
- EV-L6 (VERIFIED): synthetic MALFORMED execution `9aeaf309` → state MALFORMED, `sid=null`, fail-closed, no IRIS post, not in failure set (no dead-letter).
- EV-L1 (VERIFIED): webhook trigger `736b7410-ed6a-52af-b369-89dbef6386cb` reachable and executing; POST and even GET spawn a workflow execution.
- EV-L2 (VERIFIED): live workflow `e133a645-95b9-4e01-9454-e270d2a0b599` code inspected; guarded `deadletter()`/`notify()` writes (try/except, never raises) present for the failure set {AUTH_FAILED,TARGET_FAILED,DATASTORE_READ_FAIL,COUNTER_FAIL,UNKNOWN}.

## Backup / Rollback
No production changes made. Live read-only inspection only. The isolated synthetic replay events fired (ENV_PROBE, DATASTORE_READ_FAIL, UNKNOWN, MALFORMED) write only to the Shuffle p53_* cache namespace (dead-letter/notification) and create NO IRIS case and NO production counter increment; they are bounded and persist in Shuffle's own backend (rollback = delete those cache keys by category). TARGET_FAILED/COUNTER_FAIL live re-injection was deliberately withheld to avoid inflating the internal p53_packet_routed counter. ROUTED live re-injection (MCT_SYNTHETIC:False) was withheld to avoid creating a new production IRIS object. No docker secret, compose, or service was modified.

## Stop conditions
Production-isolation guardrail: synthetic events kept isolated from production counters/cases; no MCT_SYNTHETIC:False ROUTED injection (no new IRIS object); no AUTH_FAILED/TARGET_FAILED/COUNTER_FAIL live replay that would contact IRIS or inflate the internal routed counter. Cache/state durability across restart requires a service restart (gate). No secret value was read, printed, or rotated.

## Limitations
- MALFORMED does not write a dead-letter (by design, since no action was attempted); noted as a minor consideration.
- Synthetic-only; real missing-key events handled identically by code.

## Verdict rationale
Missing-key handling is fail-closed: no sid → MALFORMED, no route, no IRIS. Verified live. DONE.
