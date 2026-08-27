# Phase 56: SID Difference (must not duplicate)

**Report ID:** phase56-130-130-dedup-sid
**Phase:** 56
**Title:** SID Difference (must not duplicate)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/130-dedup-sid.md
**Verdict:** DONE

## Summary
Requirement: differing signature_id MUST NOT be deduped. CURRENT CODE: sid IS the first key field -> correctly distinguished. Requirement MET for SID dimension. VERIFIED.

## Evidence
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).

## Backup / Rollback
Read-only.

## Stop conditions
None (analysis only).

## Limitations
SID dimension satisfied; proto/agent remain defective.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
