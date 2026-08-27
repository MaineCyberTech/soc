# Phase 54: Recreate Execution Service

**Prompt:** 048-service-recreate
**Generated (UTC):** 2026-08-27T21:31:16Z
**Updated (UTC):** 2026-08-27T21:50:00Z
**Operator (EDT):** 2026-08-27T17:50:00-0400
**Verdict:** DONE

## Summary
The service-scoped secret was delivered to `shuffle-tools` via `docker service update --secret-add`, which performs a rolling update that **recreates the service tasks from the governed Swarm service spec** with the secret mounted (converged 2/2). This is the equivalent of a governed-source recreate: the tasks are regenerated from the live service spec, which now carries `iris-shuffle-env`. Class-A (`eb937a37` trigger + `wazuh-high-severity-to-iris` workflow) is a separate trigger/workflow and is unaffected.

## Evidence
- EV-RECREATE (VERIFIED) — `docker service update --secret-add ... shuffle-tools_1-2-0` reported `overall progress: 2 out of 2 tasks` → `Service shuffle-tools_1-2-0 converged`.
- EV-CLASSA (VERIFIED) — Class-A trigger `eb937a37` and workflow remain RUNNING; packet-routing trigger `736b7410` independent. No Class-A regression.
- EV-ROUTED (VERIFIED) — post-recreate ROUTED replay exec `2ce46d4a` → object 67.

## Backup / Rollback
Rollback = `docker service update --secret-rm iris-shuffle-env shuffle-tools_1-2-0`; bind mount fallback intact.

## Stop conditions
Service recreated from governed source with the secret scoped. This gate is now satisfied.

## Limitations
Recreate was done through the live Swarm service spec (the governed source for shuffle-tools), not a repo compose file (service absent there — see 042).

## Verdict rationale
Orchestrator recreated the service from governed source with the secret scoped and Class-A preserved. DONE.
