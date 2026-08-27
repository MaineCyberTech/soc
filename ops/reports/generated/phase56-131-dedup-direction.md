# Phase 56: Direction Difference (policy-defined)

**Report ID:** phase56-131-131-dedup-direction
**Phase:** 56
**Title:** Direction Difference (policy-defined)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/131-dedup-direction.md
**Verdict:** DONE

## Summary
Requirement: flow direction (e.g., A->B vs B->A) MUST be distinguished per policy. CURRENT CODE: key uses src/dst IPs + dest_port only; no explicit direction/orientation field -> A->B and B->A with same (sid,src_ip=A,dst_ip=B,port) are indistinguishable from a reversed tuple (sid,src_ip=B,dst_ip=A,port). Direction not governed. Defect confirmed (policy gap).

## Evidence
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).

## Backup / Rollback
Read-only; policy+fix owner-gated.

## Stop conditions
Direction policy + key extension (if required) gated at 122.

## Limitations
Direction semantics must be defined by owner (orient tuple canonicalization vs explicit direction field).

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
