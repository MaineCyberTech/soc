# Phase 56: AUTH_FAILED

**Prompt:** 184-auth
**Generated (UTC):** 2026-08-27T23:28:36Z
**Operator (EDT):** 2026-08-27T19:28:36-0400
**Verdict:** PARTIAL

## Summary
AUTH_FAILED is emitted both on token-unavailable and on IRIS 401/403; recovery rollback present. Live auth-fault replay not performed.

## Evidence
- EV-WF-SRC (VERIFIED): Live workflow source retrieved read-only via Shuffle API `GET /api/v1/workflows/e133a645-95b9-4e01-9454-e270d2a0b599`. Node `parse-eve-json` is `execute_python` (Shuffle Tools 1.2.0); full code inspected (no secret values read; token load is value-blind path-only).
- EV-TRIG (VERIFIED): `GET /api/v1/triggers` returns exactly ONE webhook `suricata-eve-in` (`736b7410-ed6a-52af-b369-89dbef6386cb`, status=running) bound to workflow e133a645-95b9-4e01-9454-e270d2a0b599. Class-A `eb937a37` (`wazuh-high-severity-to-iris`) is ABSENT from the live trigger list (matches Phase 55 drift). The webhook URL was NOT GET'd.
- EV-OS (UNVERIFIED): OpenSearch `127.0.0.1:9200` returns empty reply from host shell (ISM/capacity metrics unreadable) — Phase 55 monitoring gap carried forward; not re-litigated.
- EV-184-AF (VERIFIED, source): `load_iris_token()` returning None -> `fail("AUTH_FAILED", reason=token_unavailable)`; IRIS 401/403 -> `fail("AUTH_FAILED", http_status)`. Token is loaded value-blind from `/shuffle-files/iris-shuffle.env` or `/run/secrets/iris-shuffle.env` (path-only; value never read/printed).
- EV-184-REC (VERIFIED, source): AUTH_FAILED goes through `fail()` which rolls back the dedup mark.
- EV-184-LIVE (UNVERIFIED): Live auth-fault (force_state AUTH or invalid token) not re-driven; would require controlled POST.

## Backup / Rollback
Read-only inspection only. No workflow, datastore, IRIS, Wazuh, or host mutation was performed. Rollback is N/A; any future workflow edit (dedup-fix 122 / ttl-write 139 / counter-increment 155) requires a pre-edit backup + sha256 into `ops/backups/agents/` and owner sign-off (gated).

## Stop conditions
Live AUTH_FAILED replay requires controlled synthetic POST (execution artifact). Do not GET the webhook. IRIS token value never read/printed.

## Limitations
Auth state VERIFIED in source; runtime not re-exercised. Token path verified present on disk (`data/shuffle/files/iris-shuffle.env`).

## Verdict rationale
AUTH_FAILED state + recovery verified in live source; live fault deferred. Verdict PARTIAL.
