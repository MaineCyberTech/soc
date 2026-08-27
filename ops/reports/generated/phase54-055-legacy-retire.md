# Phase 54: Retire Legacy Bind Mount

**Prompt:** 055-legacy-retire
**Generated (UTC):** 2026-08-27T21:31:16Z
**Updated (UTC):** 2026-08-27T21:50:00Z
**Operator (EDT):** 2026-08-27T17:50:00-0400
**Verdict:** DEFERRED

## Summary
Proof that the service-scoped secret works is now achieved (ROUTED via `/run/secrets/iris-shuffle.env`, exec `2ce46d4a` → object 67). However, the orchestrator decided to **retain the legacy `/shuffle-files` bind mount as an explicit fallback** for resilience and rollback rather than removing it immediately. The overlay "prefers" the secret, which is satisfied (secret is the primary, least-privilege path); the bind remains as a non-preferred fallback. Actual removal is deferred to an explicit owner decision.

## Evidence
- EV-PROOF (VERIFIED) — ROUTED confirmed using the secret mount (exec `2ce46d4a`).
- EV-FALLBACK (VERIFIED) — `docker service inspect` shows both the `iris-shuffle-env` secret and the `/shuffle-files` bind mount present.

## Backup / Rollback
If removal is later approved: `docker service update --mount-rm /shuffle-files shuffle-tools_1-2-0`; bind mount can be re-added via `--mount-add`.

## Stop conditions
Removal deferred to owner decision; fallback retained intentionally.

## Limitations
Bind mount intentionally retained; strict least-privilege (secret-only) not yet enforced.

## Verdict rationale
Proof exists, but bind removal is deferred by orchestrator decision to keep an explicit fallback. DEFERRED.
