# Phase 54: Swarm Secret Plan

**Prompt:** 037-swarm-secret-plan
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Plan for a Docker Swarm secret: name, external declaration, grant, target, owner, rotation. Implementation deferred to orchestrator.

## Evidence
- E1-name — Proposed secret name: `iris-shuffle-env` (external, sourced from file `iris-shuffle.env`).
- E2-external — Declared `external: true` so the secret is created once by the orchestrator (not via compose `file:`), keeping it out of repo source.
- E3-grant — Granted to the IRIS-consuming execution service only (shuffle-tools / worker), mounted at `/run/secrets/iris-shuffle.env`, readonly.
- E4-owner — Secret value sourced from approved runtime store `/opt/wazuh-docker/multi-node/ops/creds.env`; managed by ops-reports/SOAR owner.
- E5-rotation — Future rotation: create new external secret, update service grant, validate ROUTED, then remove old (see 038).
- E6-no-create — No `docker secret create` executed (gate policy).

## Backup / Rollback
Revert by removing the secret grant and restoring directory bind (baseline 028).

## Stop conditions
Secret creation/grant is orchestrator-owned.

## Limitations
Plan-level; not applied. Swarm vs compose-secret choice finalized by orchestrator.

## Verdict rationale
Swarm-secret plan complete and policy-aligned. DONE (plan).
