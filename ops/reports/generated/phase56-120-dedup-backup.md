# Phase 56: Dedup Logic Backup

**Report ID:** phase56-120-120-dedup-backup
**Phase:** 56
**Title:** Dedup Logic Backup
**Date:** 2026-08-27
**Timestamp (UTC):** 2026-08-27T23:28:34Z
**Generated (UTC):** 2026-08-27T23:28:34Z
**Operator (EDT):** 2026-08-27T19:28:34-0400
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** /home/user/mct-p56/prompts/120-dedup-backup.md
**Verdict:** DONE

## Summary
Captured an immutable, read-only backup reference of the live dedup/TTL/counter workflow before any remediation. No live workflow revision performed.

## Evidence
- [VERIFIED] EV-KEY-001: SHUFFLE_API_KEY read programmatically from /opt/mct-security-stack/.env (len 36); never printed; used only in Authorization Bearer header.
- [VERIFIED] EV-WF-SRC-001: Workflow source retrieved read-only via GET /api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599 (HTTP 200). Single execute_python node 'parse-eve-json' (id 722fb255-4e6a-4d73-87f9-19c05fab1ca2) holds all dedup/TTL/counter logic. sha256(pycode)=b623e8dd4fd90a4b818e3c362e457c568aba0173f9daf3ae6833fba2b577494e ; sha256(workflow json)=61595ebdfaa31d060d508401577fff91e0047da94e2cc6d83d4e3959df239fd8.
- [VERIFIED] EV-WF-TRIG-001: GET /api/v1/triggers returned EXACTLY one webhook: 'suricata-eve-in' id 736b7410-ed6a-52af-b369-89dbef6386cb, status=running. Class-A 'wazuh-high-severity' (eb937a37-5244-46dc-95ff-62ad4c681322) is ABSENT from the live trigger list -> confirms Phase 55 Wazuh->IRIS drift.
- [VERIFIED] EV-DEDUP-KEY-001: Source line: dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port). Identity tuple = (signature_id, src_ip, dest_ip, dest_port). OMITS proto and agent -> distinct-protocol/agent events falsely collapse (DUPLICATE).
- [VERIFIED] EV-TTL-001: No TTL/expiry anywhere in source. dedup_key and counter key never expire; no datetime/utc/expir references. TTL is entirely absent.
- [VERIFIED] EV-CTR-001: Counter line: self.set_cache_value(key="p53_packet_routed", value="1", category="p53_counters"). Stores a static flag "1", NOT a cumulative atomic increment. Confirms Phase 55 counter gap.

## Backup / Rollback
Backup reference: sha256(parse-eve-json python)=b623e8dd4fd90a4b818e3c362e457c568aba0173f9daf3ae6833fba2b577494e ; sha256(full workflow json e133a645-95b9-4e01-9454-e270d2a0b599)=61595ebdfaa31d060d508401577fff91e0047da94e2cc6d83d4e3959df239fd8. Workflow created=1787717303, edited=1787864278, revision_id='' (empty in source), validation.changed_at=1787872026000. Source retained at /tmp/p56_pycode.txt and /tmp/p56_wf.json (host, not committed). Rollback = restore prior Shuffle workflow revision via Shuffle UI/API (revision_id currently empty -> rely on Shuffle version history if available).

## Stop conditions
Stop condition: any live workflow revision (incl. 122/139) is owner/orchestrator-gated (run-context §4). None performed.

## Limitations
Limitation: Shuffle revision_id empty in exported source; authoritative prior revision must be confirmed via Shuffle backend version history before any future rollback.

## Layered evidence separation
## Layered evidence separation (per run-context §5 / overlay)
- REST / API layer: workflow source + trigger state read via Shuffle API (GET /api/v1/workflows/... , GET /api/v1/triggers). EV-WF-SRC-001, EV-WF-TRIG-001.
- Webhook layer: trigger 'suricata-eve-in' 736b7410 running. Webhook URL was NEVER GET-probed (overlay hard rule; methodology incident avoided).
- Wazuh integratord / sensor-origin layer (SEPARATE, out of scope for dedup/ttl): Class-A 'wazuh-high-severity' trigger eb937a37 ABSENT from live triggers (drift, EV-WF-TRIG-001). No sensor-origin replay performed (would create IRIS objects; prohibited by run-context §5).
- task-recreation / service-recreation / Orborus-recreation / host-recovery / full-restore layers: NOT touched (read-only inspection only; all gated).

## Verdict rationale
Verdict = DONE. Read-only inspection executed against the live stack (Shuffle API, no webhook GET, no secret printed). 
