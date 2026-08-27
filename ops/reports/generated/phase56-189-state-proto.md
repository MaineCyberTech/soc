# Phase 56: Protocol Collision (Not Duplicate)

**Prompt:** 189-state-proto
**Generated (UTC):** 2026-08-27T23:28:36Z
**Operator (EDT):** 2026-08-27T19:28:36-0400
**Verdict:** BLOCKED

## Summary
Protocol collision is currently NOT treated as distinct: the dedup key omits `proto`, so distinct-protocol events falsely collapse to DUPLICATE (defect).

## Evidence
- EV-WF-SRC (VERIFIED): Live workflow source retrieved read-only via Shuffle API `GET /api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599`. Node `parse-eve-json` is `execute_python` (Shuffle Tools 1.2.0); full code inspected (no secret values read; token load is value-blind path-only).
- EV-TRIG (VERIFIED): `GET /api/v1/triggers` returns exactly ONE webhook `suricata-eve-in` (`736b7410-ed6a-52af-b369-89dbef6386cb`, status=running) bound to workflow e133a645-95b9-4e01-9454-e270d2a0b599. Class-A `eb937a37` (`wazuh-high-severity-to-iris`) is ABSENT from the live trigger list (matches Phase 55 drift). The webhook URL was NOT GET'd.
- EV-OS (UNVERIFIED): OpenSearch `127.0.0.1:9200` returns empty reply from host shell (ISM/capacity metrics unreadable) — Phase 55 monitoring gap carried forward; not re-litigated.
- EV-DEDUP (VERIFIED): `dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port)` (line 120) omits `proto`. Two events identical except for `proto` share one key -> falsely DUPLICATE. This violates the overlay requirement that dedup identity MUST include protocol.
- EV-189-DES (VERIFIED): Desired behavior ('not duplicate' on protocol collision) is NOT met by live code.

## Backup / Rollback
Read-only inspection only. No workflow, datastore, IRIS, Wazuh, or host mutation was performed. Rollback is N/A; any future workflow edit (dedup-fix 122 / ttl-write 139 / counter-increment 155) requires a pre-edit backup + sha256 into `ops/backups/agents/` and owner sign-off (gated).

## Stop conditions
Remediation requires workflow code edit (dedup-fix 122) to include `proto` in the key + an explicitly governed observer identity policy. Workflow edits are HARD-gated (run-context §4). Mark BLOCKED.

## Limitations
No live replay performed. Defect is in source, not runtime.

## Verdict rationale
Protocol field is missing from dedup identity; fix is a gated workflow edit. Verdict BLOCKED (gate 122).
