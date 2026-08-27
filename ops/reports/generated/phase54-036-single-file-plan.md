# Phase 54: Single-File Mount Plan

**Prompt:** 036-single-file-plan
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Plan to narrow the credential mount to a single read-only file target. No change implemented.

## Evidence
- E1-baseline — Current: `/opt/mct-security-stack/data/shuffle/files:/shuffle-files` (directory, read-write) on the backend.
- E2-target — Replace with a single-file, read-only mount of `iris-shuffle.env` at the path the workflow reads (either `/shuffle-files/iris-shuffle.env` or `/run/secrets/iris-shuffle.env`).
- E3-readonly — Mark `:ro` / readonly: true to remove write exposure.
- E4-scope — Grant only to the IRIS-consuming execution service (shuffle-tools / worker), not the whole backend directory.
- E5-revert — Rollback = restore directory bind from compose baseline hash 0a794710….

## Backup / Rollback
Baseline captured (028-mount-before). Orchestrator applies; revert via git.

## Stop conditions
Implementation is orchestrator-owned (gate policy 012–015); this report is plan-only.

## Limitations
Exact target path chosen by orchestrator to keep workflow `load_iris_token()` working without code change. Plan-level only.

## Verdict rationale
Single-file read-only mount plan defined; satisfies least-privilege. DONE (plan).
