# Phase 56: Pre-Fix Tests (reproduce current collisions)

**Report ID:** phase56-121-121-dedup-tests-before
**Phase:** 56
**Title:** Pre-Fix Tests (reproduce current collisions)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/121-dedup-tests-before.md
**Verdict:** DONE

## Summary
Reproduced the current dedup collision analytically from source (no live replay; would create IRIS objects). Two events sharing (sid,src,dst,port) but differing in proto or agent yield an IDENTICAL dedup_key and are falsely collapsed as DUPLICATE.

## Evidence
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).
- [VERIFIED] EV-DEDUP-OBS-001: No observer identity in dedup: source reads alert.get('proto') but NEVER alert.get('agent'); no governed observer-identity policy present. Dedup identity lacks protocol + governed observer (violates overlay/run-context §2).
- [VERIFIED] EV-DEDUP-MECH-001: Dedup uses self.check_cache_contains(key=dedup_key, value="1", append=True, category="p53_dedup"); found=True -> emit DUPLICATE; on route failure delete_cache_key rolls back the mark. Mechanism valid but identity tuple incomplete.
- [VERIFIED] EV-ROUTED-001: Carryover ROUTED proof (do not recreate): Phase 54 exec 2ce46d4a -> IRIS obj 67; Phase 55 exec 19791f62 -> IRIS obj 68. No new IRIS objects created during this pack (run-context §5).

## Backup / Rollback
Read-only; no production change. Pre-fix collision matrix documented in 134 (cert matrix).

## Stop conditions
Stop: live replay/gate 122 fix not executed (gated).

## Limitations
Limitation: collision reproduced by static analysis of identity tuple, not by live packet replay (intentionally avoided to preserve synthetic isolation / not pollute IRIS).

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
