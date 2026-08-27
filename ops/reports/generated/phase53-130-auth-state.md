# Phase 53: AUTH_FAILED

**Prompt:** 130-auth-state
**Generated (UTC):** 2026-08-27T20:07:50Z
**Operator (EDT):** 2026-08-27T16:07:50-0400
**Verdict:** DONE

## Summary
Proof that an authentication failure against IRIS (token unavailable, or 401/403 response)
emits AUTH_FAILED with NO destination object created. Fail-closed: no alert is written to IRIS.

## Evidence
- E1: triggers API — suricata-eve-in status=running.
- E2: workflow e133a645 action 722fb255 code — `if not token: return fail("AUTH_FAILED",
  {"reason": "token_unavailable", ...})`; and after the IRIS POST, `if status in (401,403):
  return fail("AUTH_FAILED", {"http_status": status})`. `fail()` rolls back the dedup mark and
  returns without an object id.
- E3: token store path /shuffle-files/iris-shuffle.env (600, gitignored) referenced by path;
  value never exposed.

## Backup / Rollback
N/A (read-only).

## Stop conditions (BLOCKED only)
None.

## Limitations
A live 401/403 was not forced (would require an invalid token, which is not exercised to
avoid polluting IRIS); the AUTH_FAILED branches in E2 are the authoritative mechanism.

## Verdict rationale
Auth failure (token missing or 401/403) => AUTH_FAILED, no object. Fail-closed. Policy satisfied.
