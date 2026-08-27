# Phase 54: Deployment Source Diff Plan

**Prompt:** 040-source-diff-plan
**Generated (UTC):** 2026-08-27T21:31:16Z
**Operator (EDT):** 2026-08-27T17:31:16-0400
**Verdict:** DONE

## Summary
Plan the minimal durable declaration for the secret-mount durability work: replace the broad `/shuffle-files` directory bind mount used by `shuffle-tools` with a service-scoped platform secret (Swarm-secret candidate) mounted at `/run/secrets/iris-shuffle.env`, preserving the deployment-durability principle that the service is recreated from governed source rather than patched in place. No mutation was performed; this is the analysis/plan artifact.

## Evidence
- EV-COMPOSE — `compose/docker-compose.shuffle.yml` line 44 binds `/opt/mct-security-stack/data/shuffle/files:/shuffle-files` (current "legacy" mount); `grep -c "secrets:"` = 0, confirming no service-scoped secret block exists yet.
- EV-DIGEST — images pinned by digest: frontend `sha256:4d700a6f…`, backend `sha256:d4a5d2bf…` (matches run-context VERIFIED STACK FACTS).
- EV-TOKEN — `/opt/mct-security-stack/data/shuffle/files/iris-shuffle.env` exists, mode 600, gitignored.

## Backup / Rollback
Orchestrator will snapshot `compose/docker-compose.shuffle.yml` and `.env` before any durable apply; rollback = revert compose to current bind-mount form (reversible, no data loss).

## Stop conditions
None for the plan. Durable apply (042) is deferred to the orchestrator.

## Limitations
Live Shuffle API returned 1 webhook (vs run-context's 6) — possible scoping; does not affect the source-diff plan which is read-only.

## Verdict rationale
Plan artifact completed via read-only evidence; the actual source diff application is contractually the orchestrator's (no compose edit by this agent).
