# Phase 56: Identical Event (must duplicate)

**Report ID:** phase56-124-124-dedup-same
**Phase:** 56
**Title:** Identical Event (must duplicate)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/124-dedup-same.md
**Verdict:** DONE

## Summary
Requirement: two genuinely identical events MUST be collapsed (DUPLICATE). Current key (sid,src,dst,port) is order/value stable for identical tuples -> identical events correctly collide to DUPLICATE. This 'must duplicate' behavior holds today and will still hold after proto/agent are added (122). VERIFIED from source.

## Evidence
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).
- [VERIFIED] EV-DEDUP-MECH-001: Dedup uses self.check_cache_contains(key=dedup_key, value="1", append=True, category="p53_dedup"); found=True -> emit DUPLICATE; on route failure delete_cache_key rolls back the mark. Mechanism valid but identity tuple incomplete.

## Backup / Rollback
Read-only.

## Stop conditions
None (analysis only).

## Limitations
Caveat: correctness here assumes the chosen identity tuple is complete; the missing proto/agent defect (125/126) is a separate dimension and does not overturn the identical-event case.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
