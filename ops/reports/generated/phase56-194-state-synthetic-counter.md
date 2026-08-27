# Phase 56: Synthetic Counters (Isolated)

**Prompt:** 194-state-synthetic-counter
**Generated (UTC):** 2026-08-27T23:28:36Z
**Operator (EDT):** 2026-08-27T19:28:36-0400
**Verdict:** PARTIAL

## Summary
Synthetic (non-fault) events are excluded from the production counter, but fault-injected synthetics still touch the flag counter, and no dedicated synthetic counter namespace exists.

## Evidence
- EV-WF-SRC (VERIFIED): Live workflow source retrieved read-only via Shuffle API `GET /api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599`. Node `parse-eve-json` is `execute_python` (Shuffle Tools 1.2.0); full code inspected (no secret values read; token load is value-blind path-only).
- EV-TRIG (VERIFIED): `GET /api/v1/triggers` returns exactly ONE webhook `suricata-eve-in` (`736b7410-ed6a-52af-b369-89dbef6386cb`, status=running) bound to workflow e133a645-95b9-4e01-9454-e270d2a0b599. Class-A `eb937a37` (`wazuh-high-severity-to-iris`) is ABSENT from the live trigger list (matches Phase 55 drift). The webhook URL was NOT GET'd.
- EV-OS (UNVERIFIED): OpenSearch `127.0.0.1:9200` returns empty reply from host shell (ISM/capacity metrics unreadable) — Phase 55 monitoring gap carried forward; not re-litigated.
- EV-194-ISO (VERIFIED, source): Synthetic events WITHOUT `MCT_FAULT` return `SYNTHETIC_TEST` before reaching the counter increment, so they do NOT increment `p53_packet_routed`. Basic isolation of clean synthetics holds.
- EV-194-GAP (VERIFIED, source): Synthetic events WITH `MCT_FAULT` (`target`/`auth`) proceed past the counter increment (which runs BEFORE the IRIS/fault branch), so they DO write the flag counter. There is no isolated synthetic counter namespace; the production flag counter is shared.
- EV-194-FLAG (VERIFIED): The counter is itself a non-atomic flag (EV-COUNTER, 193).

## Backup / Rollback
Read-only inspection only. No workflow, datastore, IRIS, Wazuh, or host mutation was performed. Rollback is N/A; any future workflow edit (dedup-fix 122 / ttl-write 139 / counter-increment 155) requires a pre-edit backup + sha256 into `ops/backups/agents/` and owner sign-off (gated).

## Stop conditions
Establishing an isolated synthetic counter namespace is a workflow code edit (counter-increment 155, synthethic-namespace) -> gated.

## Limitations
Live synthetic replay not performed. Relies on source inspection.

## Verdict rationale
Synthetic isolation is partial: clean synthetics excluded, fault-injected synthetics not; no dedicated namespace. Verdict PARTIAL.
