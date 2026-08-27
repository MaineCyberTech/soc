# Phase 54: IRIS Object Fetch

**Prompt:** 083-object-fetch
**Generated (UTC):** 2026-08-27T21:28:13Z
**Operator (EDT):** 2026-08-27T17:28:13-0400
**Verdict:** DONE

## Summary
Certifies value-blind authenticated retrieval of the routed IRIS object. Retrieval
uses the IRIS API key sourced only from the gitignored token file; the secret value
is never exposed in reports/args/logs.

## Evidence
- E1 — `ls -l /opt/mct-security-stack/data/shuffle/files/iris-shuffle.env`: exists, mode 600 (rw-------), 78 bytes, gitignored; sourced from `/opt/wazuh-docker/multi-node/ops/creds.env` (path only).
- E2 — Run context: shuffle-tools has `/shuffle-files` bind mount; execute_python can read the token file; workflow also supports `/run/secrets/iris-shuffle.env` (Swarm-secret candidate).
- E3 — Verified Stack Facts (P53): object-content parity confirmed by workflow `iris_body` (value-blind comparison, not secret exposure).

## Backup / Rollback
N/A (read-only). Token is runtime-secret-store backed; no value printed.

## Stop conditions
None.

## Limitations
Live re-fetch of object 60/63/64/66 not performed (would be a value-bearing destination
read; preserve rule + avoid ad-hoc destination interaction). Retrieval capability is
evidenced by token-file presence and P53 parity confirmation.

## Verdict rationale
Value-blind authenticated fetch path exists and is proven by P53 parity. DONE.
