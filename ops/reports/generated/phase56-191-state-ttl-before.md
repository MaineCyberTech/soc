# Phase 56: TTL Before (Duplicate)

**Prompt:** 191-state-ttl-before
**Generated (UTC):** 2026-08-27T23:28:36Z
**Operator (EDT):** 2026-08-27T19:28:36-0400
**Verdict:** BLOCKED

## Summary
No governed TTL exists in the live workflow; dedup entries have no expiry, so 'TTL before' duplicate-window semantics are unimplemented.

## Evidence
- EV-WF-SRC (VERIFIED): Live workflow source retrieved read-only via Shuffle API `GET /api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599`. Node `parse-eve-json` is `execute_python` (Shuffle Tools 1.2.0); full code inspected (no secret values read; token load is value-blind path-only).
- EV-TRIG (VERIFIED): `GET /api/v1/triggers` returns exactly ONE webhook `suricata-eve-in` (`736b7410-ed6a-52af-b369-89dbef6386cb`, status=running) bound to workflow e133a645-95b9-4e01-9454-e270d2a0b599. Class-A `eb937a37` (`wazuh-high-severity-to-iris`) is ABSENT from the live trigger list (matches Phase 55 drift). The webhook URL was NOT GET'd.
- EV-OS (UNVERIFIED): OpenSearch `127.0.0.1:9200` returns empty reply from host shell (ISM/capacity metrics unreadable) — Phase 55 monitoring gap carried forward; not re-litigated.
- EV-TTL (VERIFIED): Grep of live source finds no `TTL`/`ttl`/`expire` logic. `set_cache_value` calls (dedup, counter, deadletter, notify) pass no TTL. There is no 'TTL before' state or expiry policy.
- EV-191-DES (VERIFIED): Governed TTL (authoritative UTC, isolated namespaces) required by overlay is NOT present.

## Backup / Rollback
Read-only inspection only. No workflow, datastore, IRIS, Wazuh, or host mutation was performed. Rollback is N/A; any future workflow edit (dedup-fix 122 / ttl-write 139 / counter-increment 155) requires a pre-edit backup + sha256 into `ops/backups/agents/` and owner sign-off (gated).

## Stop conditions
Remediation requires workflow code edit (ttl-write 139) to add governed TTL using authoritative UTC + isolated synthetic namespaces. HARD-gated (run-context §4). Mark BLOCKED.

## Limitations
OpenSearch ISM/retention metrics for TTL capacity are UNVERIFIED (EV-OS).

## Verdict rationale
TTL absent from live code; fix is a gated workflow edit. Verdict BLOCKED (gate 139).
