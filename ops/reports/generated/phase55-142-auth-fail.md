# Phase 55: AUTH_FAILED — invalid secret and recovery

**Report ID:** phase55-142-auth-fail
**Phase:** 55
**Title:** AUTH_FAILED — invalid secret and recovery
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:30:00Z
**Classification:** INTERNAL
**Status:** DONE
**Source Path:** /home/user/mct-p55/prompts/142-auth-fail.md
**Prompt:** 142-auth-fail
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** DONE

## Summary
AUTH_FAILED branch (token unavailable → AUTH_FAILED + dead-letter + notification) is code-verified (EV-L2) and its recovery (dead-letter/notify) proven by the live shared failure-set write (EV-L4/EV-L5). Secret-denial / least-privilege was negatively tested live via ENV_PROBE (EV-L3): the value-blind secret is mounted at /run/secrets and /shuffle-files, and the IRIS token is NOT exposed in the environment (iris_env_keys=[]).

## Evidence
- EV-L3 (VERIFIED): synthetic ENV_PROBE execution `4ac00a91` → `secrets_dir=["iris-shuffle.env"]`, `/run/secrets/iris-shuffle.env=true` AND `/shuffle-files/iris-shuffle.env=true`, `iris_env_keys=[]` (token NOT in environment → least-privilege negative proof).
- EV-L2 (VERIFIED): live workflow `e133a645-95b9-4e01-9454-e270d2a0b599` code inspected; guarded `deadletter()`/`notify()` writes (try/except, never raises) present for the failure set {AUTH_FAILED,TARGET_FAILED,DATASTORE_READ_FAIL,COUNTER_FAIL,UNKNOWN}.
- EV-L4 (VERIFIED): synthetic DATASTORE_READ_FAIL execution `1fd33047` → state DATASTORE_READ_FAIL, `deadletter_key=p53_dl_DATASTORE_READ_FAIL_1787871841189`, `notification_key=p53_ntf_DATASTORE_READ_FAIL_1787871841201` (write succeeded; not ERR).
- EV-L9 (VERIFIED): docker secret `iris-shuffle-env` ID `4vpfvc92ice01x52qtc69yi2c`, mode 0444, service-scoped to `shuffle-tools` (value-blind; value never read/printed).

## Backup / Rollback
No production changes made. Live read-only inspection only. The isolated synthetic replay events fired (ENV_PROBE, DATASTORE_READ_FAIL, UNKNOWN, MALFORMED) write only to the Shuffle p53_* cache namespace (dead-letter/notification) and create NO IRIS case and NO production counter increment; they are bounded and persist in Shuffle's own backend (rollback = delete those cache keys by category). TARGET_FAILED/COUNTER_FAIL live re-injection was deliberately withheld to avoid inflating the internal p53_packet_routed counter. ROUTED live re-injection (MCT_SYNTHETIC:False) was withheld to avoid creating a new production IRIS object. No docker secret, compose, or service was modified.

## Stop conditions
Production-isolation guardrail: synthetic events kept isolated from production counters/cases; no MCT_SYNTHETIC:False ROUTED injection (no new IRIS object); no AUTH_FAILED/TARGET_FAILED/COUNTER_FAIL live replay that would contact IRIS or inflate the internal routed counter. Cache/state durability across restart requires a service restart (gate). No secret value was read, printed, or rotated.

## Limitations
- Live AUTH_FAILED replay via fault="auth" would POST to real IRIS with an invalid token (contact, no object) — withheld per isolation; branch + recovery proven by code and shared write path.
- Negative test confirms token load is file-based and value-blind; no secret value read or printed.

## Verdict rationale
Invalid-secret handling and recovery verified: failure set includes AUTH_FAILED and the dead-letter/notify write is proven live; secret is mounted service-scoped and least-privilege (not in env). DONE for secret-denial + recovery; specific live trigger gated.
