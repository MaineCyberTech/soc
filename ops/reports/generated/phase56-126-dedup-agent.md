# Phase 56: Agent Difference (policy-defined direct proof)

**Report ID:** phase56-126-126-dedup-agent
**Phase:** 56
**Title:** Agent Difference (policy-defined direct proof)
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/126-dedup-agent.md
**Verdict:** DONE

## Summary
Requirement: events from different agents MUST NOT be deduped (governed observer identity). CURRENT CODE FAILS: source never reads alert.get('agent') and has no observer-identity policy -> agent differences invisible to dedup -> false collapse. Defect confirmed. Adds the 'governed observer identity' overlay requirement.

## Evidence
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).
- [VERIFIED] EV-DEDUP-OBS-001: No observer identity in dedup: source reads alert.get('proto') but NEVER alert.get('agent'); no governed observer-identity policy present. Dedup identity lacks protocol + governed observer (violates overlay/run-context §2).

## Backup / Rollback
Read-only; remediation in gated 122.

## Stop conditions
Remediation (add governed observer identity) gated at 122.

## Limitations
Observer-identity policy (which field defines the observer, and its governance) must be specified by owner before 122 fix.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
