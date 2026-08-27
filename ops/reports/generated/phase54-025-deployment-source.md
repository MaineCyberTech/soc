# Phase 54: Deployment Source Inventory

**Prompt:** 025-deployment-source
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Identified the deployment source artifacts (Compose stack files) and the live service spec relevant to secret-mount engineering.

## Evidence
- E1-compose-dir — `compose/` contains: docker-compose.dfir-iris.yml, docker-compose.greenbone.yml, docker-compose.misp.yml, docker-compose.opencanary.yml, docker-compose.phase2.yml, docker-compose.shuffle.yml, docker-compose.velociraptor.yml.
- E2-shuffle-compose — `docker-compose.shuffle.yml` (hash sha256 0a794710…0427b) defines shuffle-frontend/backend/orborus/opensearch/tls-proxy. Backend mounts `/opt/mct-security-stack/data/shuffle/files:/shuffle-files` (broad directory bind).
- E3-live-spec — Shuffle backend container runs with that bind mount; token file `iris-shuffle.env` lives under it.
- E4-git — Source tree HEAD 2807284… (7184 tracked files).

## Backup / Rollback
Source controlled by git (HEAD 2807284). Orborus/implementation codification owned by orchestrator per gate policy.

## Stop conditions
None for read-only inventory.

## Limitations
Other compose files (iris/misp/greenbone/etc.) not inspected in detail; only shuffle compose governs the credential mount in scope.

## Verdict rationale
Deployment source + live spec identified; broad bind mount confirmed as the target for narrowing to a service-scoped secret.
