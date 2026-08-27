# Phase 56: Agent Collision (Policy Result)

**Prompt:** 190-state-agent
**Generated (UTC):** 2026-08-27T23:28:36Z
**Operator (EDT):** 2026-08-27T19:28:36-0400
**Verdict:** BLOCKED

## Summary
Agent collision is NOT isolated: dedup key omits `agent` (the field is never even read), so distinct-agent events falsely collapse (defect).

## Evidence
- EV-WF-SRC (VERIFIED): Live workflow source retrieved read-only via Shuffle API `GET /api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599`. Node `parse-eve-json` is `execute_python` (Shuffle Tools 1.2.0); full code inspected (no secret values read; token load is value-blind path-only).
- EV-TRIG (VERIFIED): `GET /api/v1/triggers` returns exactly ONE webhook `suricata-eve-in` (`736b7410-ed6a-52af-b369-89dbef6386cb`, status=running) bound to workflow e133a645-95b9-4e01-9454-e270d2a0b599. Class-A `eb937a37` (`wazuh-high-severity-to-iris`) is ABSENT from the live trigger list (matches Phase 55 drift). The webhook URL was NOT GET'd.
- EV-OS (UNVERIFIED): OpenSearch `127.0.0.1:9200` returns empty reply from host shell (ISM/capacity metrics unreadable) — Phase 55 monitoring gap carried forward; not re-litigated.
- EV-190-AG (VERIFIED): Source reads `proto` but never reads an `agent`/`agent_id` field, and the dedup key (line 120) omits it. Distinct-agent events thus collapse to DUPLICATE. Overlay requires dedup identity to include an explicitly governed observer identity policy.
- EV-190-DES (VERIFIED): Desired agent-aware isolation is NOT present.

## Backup / Rollback
Read-only inspection only. No workflow, datastore, IRIS, Wazuh, or host mutation was performed. Rollback is N/A; any future workflow edit (dedup-fix 122 / ttl-write 139 / counter-increment 155) requires a pre-edit backup + sha256 into `ops/backups/agents/` and owner sign-off (gated).

## Stop conditions
Remediation requires workflow code edit (dedup-fix 122) adding `agent` + governed observer identity policy. HARD-gated (run-context §4). Mark BLOCKED.

## Limitations
No live replay. Defect in source.

## Verdict rationale
Agent identity absent from dedup; fix is a gated workflow edit. Verdict BLOCKED (gate 122).
