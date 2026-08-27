# Phase 56: Missing Identity (fail closed or abstain)

**Report ID:** phase56-133-133-dedup-missing
**Phase:** 56
**Title:** Missing Identity (fail closed or abstain)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/133-dedup-missing.md
**Verdict:** DONE

## Summary
Requirement: if a required identity field is missing, the workflow MUST fail closed or abstain (not route, not falsely collapse). CURRENT CODE: only sid-missing triggers fail-closed (MALFORMED, early return, no dedup/route). proto/agent are not in the key today, so missing proto/agent is silently treated as empty-string (no fail-closed, no abstain) -> governance gap. After 122 adds proto/agent+observer, missing values MUST be made fail-closed/abstain. Documented.

## Evidence
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).
- [VERIFIED] EV-DEDUP-OBS-001: No observer identity in dedup: source reads alert.get('proto') but NEVER alert.get('agent'); no governed observer-identity policy present. Dedup identity lacks protocol + governed observer (violates overlay/run-context §2).

## Backup / Rollback
Read-only.

## Stop conditions
Missing-identity fail-closed handling to be added in gated 122.

## Limitations
Current fail-closed only covers sid; post-122 identity fields need explicit fail-closed/abstain policy from owner.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
