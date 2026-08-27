# Phase 54: IRIS Correlation

**Prompt:** 165-iris-correlation
**Generated (UTC):** 2026-08-27T21:29:08Z
**Operator (EDT):** 2026-08-27T17:29:08-0400
**Verdict:** DONE

## Summary
Read-only correlation of the destination IRIS object layer with the ROUTED evidence. Confirms the
token store is present and ROUTED was proven live (HTTP 200 + object-content parity) without fetching
or mutating any IRIS object.

## Evidence
- E1 (token store) — /opt/mct-security-stack/data/shuffle/files/iris-shuffle.env exists, mode 600,
  gitignored; sourced from /opt/wazuh-docker/multi-node/ops/creds.env. Contents NOT printed.
- E2 (run-context, ROUTED proven live) — real IRIS alerts 63, 64, 66 created via HTTP 200 with
  object-content parity confirmed by workflow `iris_body`. Historical first live ROUTED
  exec 4d5b9d15 -> object 60 PRESERVED.
- E3 (run-context) — workflow supports /run/secrets/iris-shuffle.env (Swarm-secret candidate); secret
  value lives only in approved runtime secret store, never in reports.

## Backup / Rollback
N/A — read-only. No IRIS object fetched or modified.

## Stop conditions (BLOCKED only)
N/A.

## Limitations
No direct IRIS API query was performed in this batch (would require the secret token); ROUTED-proof is
cited from the verified stack facts. Object IDs 60/63/64/66 referenced by ID only.

## Verdict rationale
Destination layer confirmed reachable in prior proof; token store present and secret-scoped; object
IDs referenced without exposure. No mutating action.
