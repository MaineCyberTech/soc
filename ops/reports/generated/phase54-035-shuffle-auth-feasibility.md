# Phase 54: Shuffle Auth Object Feasibility

**Prompt:** 035-shuffle-auth-feasibility
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Compared a native Shuffle auth object (e.g. app auth / environment variable) with file-based token access for the IRIS credential.

## Evidence
- E1-file — Current approach: IRIS_API_KEY read from `/shuffle-files/iris-shuffle.env` by workflow Python. Works (ROUTED proven) but depends on a broad bind mount.
- E2-native — Shuffle supports app-level authentication objects / environment variables that could hold the token per-app, avoiding the directory bind entirely.
- E3-tradeoff — Native auth object is service-scoped and survives container recreation, but couples the secret to Shuffle's app config; a Swarm secret mounted read-only is the preferred P54 path (per overlay "PREFER service-scoped platform secrets over broad directory bind mounts when the app supports them").
- E4-no-change — No auth object created or altered.

## Backup / Rollback
N/A (analysis).

## Stop conditions
None for feasibility.

## Limitations
Native auth-object implementation not prototyped (would require Shuffle UI/API mutation). Comparison is design-level.

## Verdict rationale
Both file and native auth object are feasible; service-scoped Swarm secret is preferred per overlay. Analysis DONE.
