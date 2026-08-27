# Phase 56: IRIS Object Hygiene (Labeled Test)

**Prompt:** 195-state-object
**Generated (UTC):** 2026-08-27T23:28:36Z
**Operator (EDT):** 2026-08-27T19:28:36-0400
**Verdict:** PARTIAL

## Summary
Synthetic IRIS objects are NOT distinctly labeled; the only marker (`test:true`) is applied to ALL routes including production, so synthetic isolation at the IRIS object layer is incomplete.

## Evidence
- EV-WF-SRC (VERIFIED): Live workflow source retrieved read-only via Shuffle API `GET /api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599`. Node `parse-eve-json` is `execute_python` (Shuffle Tools 1.2.0); full code inspected (no secret values read; token load is value-blind path-only).
- EV-TRIG (VERIFIED): `GET /api/v1/triggers` returns exactly ONE webhook `suricata-eve-in` (`736b7410-ed6a-52af-b369-89dbef6386cb`, status=running) bound to workflow e133a645-95b9-4e01-9454-e270d2a0b599. Class-A `eb937a37` (`wazuh-high-severity-to-iris`) is ABSENT from the live trigger list (matches Phase 55 drift). The webhook URL was NOT GET'd.
- EV-OS (UNVERIFIED): OpenSearch `127.0.0.1:9200` returns empty reply from host shell (ISM/capacity metrics unreadable) — Phase 55 monitoring gap carried forward; not re-litigated.
- EV-195-TAG (VERIFIED, source): `alert_tags` is hardcoded `"source:suricata,class:A,test:true"` for every IRIS POST, production and synthetic alike. There is no synthetic-specific label (e.g. `MCT_SYNTHETIC`) added when a synthetic is force-routed (`force_state=='ROUTED'`).
- EV-195-CARRY (VERIFIED, carryover): Carryover ROUTED objects 67 (Phase 54) and 68 (Phase 55) were created via real replays tagged `test:true`; no separate synthetic-labeled object was produced in this pack (overlay forbids new IRIS ROUTED objects).

## Backup / Rollback
Read-only inspection only. No workflow, datastore, IRIS, Wazuh, or host mutation was performed. Rollback is N/A; any future workflow edit (dedup-fix 122 / ttl-write 139 / counter-increment 155) requires a pre-edit backup + sha256 into `ops/backups/agents/` and owner sign-off (gated).

## Stop conditions
Labeling fix requires workflow code edit (add synthetic-specific tag + exclusion handling). Gated. Do NOT create new IRIS objects in this pack.

## Limitations
Live IRIS object inspection limited to carryover (67/68); no new objects created. IRIS API not authenticated in this pack (token value never read).

## Verdict rationale
Synthetic IRIS objects lack a distinct label; production and synthetic share `test:true`. Verdict PARTIAL (gap VERIFIED; labeling fix gated).
