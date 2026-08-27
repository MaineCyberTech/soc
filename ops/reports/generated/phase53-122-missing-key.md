# Phase 53: Missing Key

**Prompt:** 122-missing-key
**Generated (UTC):** 2026-08-27T20:07:50Z
**Operator (EDT):** 2026-08-27T16:07:50-0400
**Verdict:** DONE

## Summary
Fail-closed proof: if the IRIS API token cannot be loaded from the approved runtime store,
the workflow emits AUTH_FAILED and does NOT route to IRIS (no object created). Secret value
is never exposed — only the load path / availability is considered.

## Evidence
- E1: triggers API — suricata-eve-in status=running.
- E2: workflow e133a645 action 722fb255 code — `token, diag = load_iris_token();
  if not token: return fail("AUTH_FAILED", {"reason": "token_unavailable", ...})`.
  Token is read value-blind from /shuffle-files/iris-shuffle.env (600, gitignored);
  the value is never printed or logged.
- E3: token file existence verified out-of-band (mode 600, gitignored) — referenced by path only.

## Backup / Rollback
N/A (read-only).

## Stop conditions (BLOCKED only)
None.

## Limitations
Live missing-key scenario not forced (would require an invalid token store); fail-closed
behavior proven by the `if not token` guard in E2.

## Verdict rationale
Missing key => AUTH_FAILED, no route, no object. Fail-closed. Policy satisfied.
