# Phase 56: Dedup Correctness Certificate (matrix)

**Report ID:** phase56-134-134-dedup-cert
**Phase:** 56
**Title:** Dedup Correctness Certificate (matrix)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/134-dedup-cert.md
**Verdict:** DONE

## Summary
Synthesis correctness matrix across dedup dimensions (124-133), all from the single live source. PASS: identical(124), source(127), dest(128), port(129), sid(130), reorder(132). FAIL (defect): proto(125), agent/observer(126), direction(131), missing-identity governance(133). Root cause unified: dedup_key omits proto+agent+observer-identity and lacks missing-value fail-closed. Fix gated at 122.

## Evidence
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).
- [VERIFIED] EV-DEDUP-OBS-001: No observer identity in dedup: source reads alert.get('proto') but NEVER alert.get('agent'); no governed observer-identity policy present. Dedup identity lacks protocol + governed observer (violates overlay/run-context §2).
- [VERIFIED] EV-DEDUP-MECH-001: Dedup uses self.check_cache_contains(key=dedup_key, value="1", append=True, category="p53_dedup"); found=True -> emit DUPLICATE; on route failure delete_cache_key rolls back the mark. Mechanism valid but identity tuple incomplete.

## Backup / Rollback
Read-only; matrix references 120-133.

## Stop conditions
Remediation gated at 122.

## Limitations
Matrix is from static source analysis; live replay avoided per run-context §5.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
