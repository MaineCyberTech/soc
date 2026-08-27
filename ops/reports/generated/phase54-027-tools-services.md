# Phase 54: shuffle-tools Service Pattern

**Prompt:** 027-tools-services
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Identified the Orborus-managed execution service variant (shuffle-tools) that runs workflow `execute_python` actions and therefore needs access to the IRIS token.

## Evidence
- E1-tools-svc — `shuffle-tools_1-2-0` (image frikky/shuffle:shuffle-tools_1.2.0), replicated 2/2, published :33334. This is the worker/execution app image family used by Shuffle to run app actions including `execute_python`.
- E2-orborus — `shuffle-orborus` (compose) spins up execution containers; worker image pinned by digest.
- E3-consumer — The `suricata-packet-routing` (e133a645) and `wazuh-high-severity-to-iris` (eb937a37) workflows execute Python that loads the IRIS token from `/shuffle-files/iris-shuffle.env`; that file is reached via the backend bind mount and is visible to execution apps.
- E4-alt — Workflow also supports `/run/secrets/iris-shuffle.env` (Swarm-secret candidate) per run-context.

## Backup / Rollback
N/A.

## Stop conditions
None.

## Limitations
Direct confirmation that the tools container mounts `/shuffle-files` would require `docker inspect` of the running task; inferred from the backend bind pattern and run-context. Marked PARTIAL-confidence for the container-level mount but VERIFIED at compose level.

## Verdict rationale
Execution-service pattern identified; shuffle-tools is the consumer target for a service-scoped secret.
