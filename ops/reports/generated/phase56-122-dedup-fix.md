# Phase 56: Dedup Fix (add protocol + governed observer identity)

**Report ID:** phase56-122-122-dedup-fix
**Phase:** 56
**Title:** Dedup Fix (add protocol + governed observer identity)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** BLOCKED
**Source Path:** /home/user/mct-p56/prompts/122-dedup-fix.md
**Verdict:** DONE

## Summary
Read-only source inspection complete. The required fix (add proto + agent + a governed observer-identity policy to dedup_key) is a LIVE WORKFLOW CODE EDIT and is explicitly gated (run-context §4). NOT applied.

## Evidence
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).
- [VERIFIED] EV-DEDUP-OBS-001: No observer identity in dedup: source reads alert.get('proto') but NEVER alert.get('agent'); no governed observer-identity policy present. Dedup identity lacks protocol + governed observer (violates overlay/run-context §2).
- [VERIFIED] EV-DEDUP-MECH-001: Dedup uses self.check_cache_contains(key=dedup_key, value="1", append=True, category="p53_dedup"); found=True -> emit DUPLICATE; on route failure delete_cache_key rolls back the mark. Mechanism valid but identity tuple incomplete.

## Backup / Rollback
Pre-change backup captured: sha256(pycode)=b623e8dd4fd90a4b818e3c362e457c568aba0173f9daf3ae6833fba2b577494e (see 120).

## Stop conditions
STOP at gate: workflow code edit (dedup-fix 122) requires owner/orchestrator sign-off. Do NOT mutate live workflow. Marked BLOCKED.

## Limitations
Required remediation left to owner: extend dedup_key to include proto + agent + governed observer identity; define observer-identity policy (which sensor/observer asserts identity).

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = BLOCKED. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed).

## Remediation (orchestrator, 2026-08-28T00:30Z)
- Dedup key rewritten to `p53_dedup_%s_%s_%s_%s_%s_%s` = (sid, src, dst, port, proto, governed observer identity). Verified: a repeat of an identical 5-tuple now returns DUPLICATE (was previously collapsing distinct proto/agent events). Live workflow `e133a645` updated via Shuffle API; ROUTED re-proof created IRIS objects 69/71/72/73.
