# Phase 56: TTL Key Namespace (versioned + synthetic isolated)

**Report ID:** phase56-138-138-ttl-key
**Phase:** 56
**Title:** TTL Key Namespace (versioned + synthetic isolated)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/138-ttl-key.md
**Verdict:** DONE

## Summary
Read-only: TTL/counter keys are unversioned (p53_dedup, p53_packet_routed, p53_deadletter, p53_notifications) and NOT synthetically isolated (MCT_SYNTHETIC flag does not partition keys). Requirement (versioned + isolated synthetic namespace) is UNMET. Documented; remediation in gated 139 + 123.

## Evidence
- [VERIFIED] EV-CACHE-NS-001: Cache categories used: p53_dedup, p53_counters, p53_deadletter, p53_notifications. No version suffix and NO synthetic-isolation namespace; synthetic flag MCT_SYNTHETIC does not partition cache keys (violates synthetic-isolation + versioning requirements).
- [VERIFIED] EV-TTL-001: No TTL/expiry anywhere in source. dedup_key and counter key never expire; no datetime/utc/expir references. TTL is entirely absent.

## Backup / Rollback
Read-only.

## Stop conditions
Namespacing write gated at 139/123.

## Limitations
Synthetic-isolation + version prefix scheme must be defined by owner before write.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
