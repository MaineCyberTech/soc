# Phase 54: IRIS Token Privilege

**Prompt:** 032-token-privilege
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Assessed the IRIS API token's privilege posture without exposing the value.

## Evidence
- E1-storage — Token stored at `/opt/mct-security-stack/data/shuffle/files/iris-shuffle.env` (mode 600), sourced from `/opt/wazuh-docker/multi-node/ops/creds.env`. Referenced by path only; value not printed.
- E2-scope — Used solely for Shuffle→IRIS alert creation (POST /alerts). It is an IRIS API key, not a Shuffle or host credential.
- E3-least-priv — File is owner-only readable (600) and gitignored — satisfies secret-handling. Preferred posture: service-scoped Swarm secret mounted read-only into the IRIS-consuming execution app only (P54 goal), rather than a broad directory bind on the backend.
- E4-rotation — Token rotation is owner-gated (run-context approval gates); not performed here.

## Backup / Rollback
N/A.

## Stop conditions
Token rotation/revocation requires owner sign-off (approval-gated).

## Limitations
IRIS-side role/scope (e.g. admin vs. analyst) cannot be introspected without the value or an authenticated IRIS API call that would print identity; not attempted. Posture assessed from storage + usage only.

## Verdict rationale
Token is least-privilege in storage and purpose; narrowing the mount further reduces blast radius. DONE (analysis).
