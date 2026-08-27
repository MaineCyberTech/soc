# Phase 56: TTL Write (store timestamp/expiry)

**Report ID:** phase56-139-139-ttl-write
**Phase:** 56
**Title:** TTL Write (store timestamp/expiry)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** BLOCKED
**Source Path:** /home/user/mct-p56/prompts/139-ttl-write.md
**Verdict:** BLOCKED

## Summary
Read-only inspection complete. Writing an authoritative-UTC timestamp/expiry into the dedup/counter keys is a LIVE WORKFLOW CODE EDIT and explicitly gated (run-context §4). NOT applied.

## Evidence
- [VERIFIED] EV-TTL-001: No TTL/expiry anywhere in source. dedup_key and counter key never expire; no datetime/utc/expir references. TTL is entirely absent.
- [VERIFIED] EV-TTL-CLK-001: Timestamps in code use time.time() (worker-local epoch seconds); no authoritative UTC source and no clock-skew handling. Violates run-context §2 (TTL must use authoritative UTC).
- [VERIFIED] EV-CACHE-NS-001: Cache categories used: p53_dedup, p53_counters, p53_deadletter, p53_notifications. No version suffix and NO synthetic-isolation namespace; synthetic flag MCT_SYNTHETIC does not partition cache keys (violates synthetic-isolation + versioning requirements).

## Backup / Rollback
Pre-change backup: sha256(pycode)=b623e8dd4fd90a4b818e3c362e457c568aba0173f9daf3ae6833fba2b577494e (see 120).

## Stop conditions
STOP at gate: workflow code edit (ttl-write 139) requires owner/orchestrator sign-off. Do NOT mutate live workflow. Marked BLOCKED.

## Limitations
Required: store UTC expiry per key in isolated synthetic namespace; backend TTL support must be confirmed first (137).

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = BLOCKED. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
