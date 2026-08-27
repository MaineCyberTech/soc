# Phase 56: TTL Requirements (value, owner, test/production separation)

**Report ID:** phase56-135-135-ttl-requirements
**Phase:** 56
**Title:** TTL Requirements (value, owner, test/production separation)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/135-ttl-requirements.md
**Verdict:** DONE

## Summary
Read-only analysis of TTL requirements vs current code. FINDING: NO TTL exists anywhere (EV-TTL-001). Requirements per run-context §2/overlay: TTL must (a) carry an explicit value, (b) have a defined owner, (c) separate test vs production, (d) use authoritative UTC, (e) use isolated synthetic namespaces. None currently implemented. Documented; remediation gated at 139.

## Evidence
- [VERIFIED] EV-TTL-001: No TTL/expiry anywhere in source. dedup_key and counter key never expire; no datetime/utc/expir references. TTL is entirely absent.
- [VERIFIED] EV-TTL-CLK-001: Timestamps in code use time.time() (worker-local epoch seconds); no authoritative UTC source and no clock-skew handling. Violates run-context §2 (TTL must use authoritative UTC).
- [VERIFIED] EV-CACHE-NS-001: Cache categories used: p53_dedup, p53_counters, p53_deadletter, p53_notifications. No version suffix and NO synthetic-isolation namespace; synthetic flag MCT_SYNTHETIC does not partition cache keys (violates synthetic-isolation + versioning requirements).

## Backup / Rollback
Read-only.

## Stop conditions
TTL write (139) is a live workflow revision -> gated.

## Limitations
TTL value/owner not yet defined by owner; required before 139 execution.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
