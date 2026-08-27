# Phase 55: TARGET_FAILED — fault and recovery

**Report ID:** phase55-141-target-fail
**Phase:** 55
**Title:** TARGET_FAILED — fault and recovery
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:30:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** /home/user/mct-p55/prompts/141-target-fail.md
**Prompt:** 141-target-fail
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** PARTIAL

## Summary
TARGET_FAILED failure branch and its guarded dead-letter/notification recovery are proven by code equivalence (EV-L2) and by the live dead-letter/notification mechanism (EV-L4/EV-L5, same failure set). Live TARGET_FAILED re-injection (fault="target") was withheld because it first increments the internal p53_packet_routed counter before failing, which would inflate a production-relevant counter.

## Evidence
- EV-L2 (VERIFIED): live workflow `e133a645-95b9-4e01-9454-e270d2a0b599` code inspected; guarded `deadletter()`/`notify()` writes (try/except, never raises) present for the failure set {AUTH_FAILED,TARGET_FAILED,DATASTORE_READ_FAIL,COUNTER_FAIL,UNKNOWN}.
- EV-L4 (VERIFIED): synthetic DATASTORE_READ_FAIL execution `1fd33047` → state DATASTORE_READ_FAIL, `deadletter_key=p53_dl_DATASTORE_READ_FAIL_1787871841189`, `notification_key=p53_ntf_DATASTORE_READ_FAIL_1787871841201` (write succeeded; not ERR).
- EV-L5 (VERIFIED): synthetic UNKNOWN execution `87a88bed` → state UNKNOWN (forced), dead-letter + notification keys written.
- EV-L10 (VERIFIED): prior empty-argument execution `d5fbf917` → UNKNOWN + dead-letter path exercised live (failure handling proven end-to-end).

## Backup / Rollback
No production changes made. Live read-only inspection only. The isolated synthetic replay events fired (ENV_PROBE, DATASTORE_READ_FAIL, UNKNOWN, MALFORMED) write only to the Shuffle p53_* cache namespace (dead-letter/notification) and create NO IRIS case and NO production counter increment; they are bounded and persist in Shuffle's own backend (rollback = delete those cache keys by category). TARGET_FAILED/COUNTER_FAIL live re-injection was deliberately withheld to avoid inflating the internal p53_packet_routed counter. ROUTED live re-injection (MCT_SYNTHETIC:False) was withheld to avoid creating a new production IRIS object. No docker secret, compose, or service was modified.

## Stop conditions
Production-isolation guardrail: synthetic events kept isolated from production counters/cases; no MCT_SYNTHETIC:False ROUTED injection (no new IRIS object); no AUTH_FAILED/TARGET_FAILED/COUNTER_FAIL live replay that would contact IRIS or inflate the internal routed counter. Cache/state durability across restart requires a service restart (gate). No secret value was read, printed, or rotated.

## Limitations
- Live TARGET_FAILED replay not fired: the fault path increments p53_packet_routed (set_cache_value) before the IRIS post, contrary to isolation; verified instead by code equivalence and the shared dead-letter/notify write path.
- No direct EV showing a TARGET_FAILED-named dead-letter key (would require the withheld replay).

## Verdict rationale
Recovery (dead-letter + notification) is the identical guarded write used and proven for DATASTORE_READ_FAIL/UNKNOWN; TARGET_FAILED reaches the same failure set. Marked PARTIAL: branch code-verified + recovery-proven, live trigger gated by counter-isolation.
