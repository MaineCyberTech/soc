# Phase 56: Secret Denial Matrix

**Prompt:** 011-p55-secret-matrix
**Generated (UTC):** 2026-08-27T23:35:00Z
**Operator (EDT):** 2026-08-27T19:35:00-0400
**Verdict:** DONE

## Summary
Documented the services tested for the `iris-shuffle-env` Swarm secret grant and the explicit limits of the negative conclusion.

## Evidence
- EV-SECRET-001 (VERIFIED): `docker secret inspect iris-shuffle-env` → ID `4vpfvc92ice01x52qtc69yi2c`, mode 0444 (0o444), no labels.
- EV-SECRET-002 (VERIFIED): granted (via `ContainerSpec.Secrets`) ONLY to `shuffle-tools_1-2-0`, mounted as `iris-shuffle.env` (UID 0, mode 292=0444). Negative proof: loop over all 7 Swarm services (`email_1-3-0`, `http_1-4-0`, `shuffle-ai_1-1-0`, `shuffle-subflow_1-1-0`, `shuffle-tools_1-2-0`, `shuffle-workers`, `shufflehealthcheck_1-1-0`) found the grant in exactly 1 (shuffle-tools). Backend/orborus/other apps: 0 grants.

## Backup-Rollback
Read-only. N/A.

## Stop conditions
None. No secret rotated/created.

## Limitations
Negative proof covers Swarm `ContainerSpec.Secrets` only. It does not prove absence of (a) OS-level file copies inside a container, (b) runtime env injection outside Swarm secrets, or (c) historical exposure prior to P54 creation. The Swarm spec is the authoritative governance surface; filesystem-level and historical assertions remain owner-accepted limitations (consistent with P55 PARTIALs).

## Verdict rationale
Denial matrix established with VERIFIED negative proof across all live Swarm services; limits documented → DONE.
