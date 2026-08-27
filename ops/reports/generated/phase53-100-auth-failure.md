# Phase 53: AUTH_FAILED Regression

**Prompt:** 100-auth-failure
**Generated (UTC):** 2026-08-27T20:08:15Z
**Operator (EDT):** 2026-08-27T16:08:15-0400
**Verdict:** DONE

## Summary
Verified the fail-closed behavior: an invalid or missing bearer token is rejected (401) and does not reach IRIS. This protects against AUTH_FAILED regressions on both the Shuffle API and (by design) the IRIS call.

## Evidence
- E3: `GET /api/v1/workflows` WITHOUT Authorization -> 401; WITH invalid token `invalid_token_xyz` -> 401. (Shuffle API fails closed.)
- E6: IRIS call uses a Bearer header built in-memory from the runtime secret; an empty/invalid token would yield a non-200 and the workflow would not reach ROUTED (no object created), consistent with AUTH_FAILED semantics.
- E5: only the valid runtime reference produced ROUTED (object 60); no stray/duplicate object from bad auth observed.

## Backup / Rollback
N/A (read-only regression check).

## Stop conditions
None.

## Limitations
A deliberately-invalid IRIS token was not sent to IRIS (would create an auth-failure object / alert noise). Fail-closed is evidenced at the Shuffle API layer and by the workflow's design (no object created unless 200).

## Verdict rationale
Invalid/missing auth fails closed (401, no object) -> regression not present.
