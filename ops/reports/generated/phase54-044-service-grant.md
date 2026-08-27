# Phase 54: Grant Secret to Execution Service

**Prompt:** 044-service-grant
**Generated (UTC):** 2026-08-27T21:31:16Z
**Updated (UTC):** 2026-08-27T21:50:00Z
**Operator (EDT):** 2026-08-27T17:50:00-0400
**Verdict:** DONE

## Summary
Orchestrator granted the `iris-shuffle-env` secret to the **single intended execution service** `shuffle-tools` only (service-scoped, not a broad directory bind mount). Mount target: `/run/secrets/iris-shuffle.env`, mode 0444. `docker service update --secret-add source=iris-shuffle-env,target=iris-shuffle.env shuffle-tools_1-2-0` converged (2/2 tasks). The legacy `/shuffle-files` bind mount remains as an explicit fallback; the secret is now the primary, least-privilege path.

## Evidence
- EV-GRANT (VERIFIED) — `docker service inspect shuffle-tools_1-2-0` shows `SecretName: iris-shuffle-env`, `File.Name: iris-shuffle.env`, `Mode: 292` (0o444), and `Mounts` still includes the bind `/shuffle-files` (fallback).
- EV-ROUTED (VERIFIED) — ROUTED replay via exec `2ce46d4a` → object 67, confirming the workflow reads `/run/secrets/iris-shuffle.env`.

## Backup / Rollback
Rollback = `docker service update --secret-rm iris-shuffle-env shuffle-tools_1-2-0`; bind-mount fallback preserves function.

## Stop conditions
Secret granted to `shuffle-tools` only. This gate is now satisfied.

## Limitations
Grant is in the live Swarm service spec (governed source for shuffle-tools; see 042/057).

## Verdict rationale
Orchestrator scoped the secret to the single intended service. DONE.
