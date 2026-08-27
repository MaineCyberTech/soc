# Phase 56: Dedup Cache Migration (avoid cross-version collision)

**Report ID:** phase56-123-123-dedup-migration
**Phase:** 56
**Title:** Dedup Cache Migration (avoid cross-version collision)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** PARTIAL
**Source Path:** /home/user/mct-p56/prompts/123-dedup-migration.md
**Verdict:** PARTIAL

## Summary
Read-only analysis: current dedup keys are unversioned (p53_dedup_%s...). When 122 changes the key format, prior-format entries in category p53_dedup persist and could collide or leak. Mitigation = versioned key namespace (e.g., p53_dedup_v2_<...>) plus optional synthetic-isolation prefix. The actual key-namespace write is a workflow revision (gated via 122).

## Evidence
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).
- [VERIFIED] EV-CACHE-NS-001: Cache categories used: p53_dedup, p53_counters, p53_deadletter, p53_notifications. No version suffix and NO synthetic-isolation namespace; synthetic flag MCT_SYNTHETIC does not partition cache keys (violates synthetic-isolation + versioning requirements).

## Backup / Rollback
Read-only; no cache write. Design noted for owner.

## Stop conditions
STOP at gate: writing the new versioned key format into the live workflow is a revision (run-context §4).

## Limitations
PARTIAL: analysis + design complete; migration write deferred to gated 122 execution.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = PARTIAL. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
