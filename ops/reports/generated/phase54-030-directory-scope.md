# Phase 54: Directory Exposure Audit

**Prompt:** 030-directory-scope
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Audited the breadth of files exposed through the broad `/shuffle-files` bind mount (filenames only; no values).

## Evidence
- E1-listing — Host dir `data/shuffle/files/` exposes ONLY: `iris-shuffle.env` (the credential) and the org subdir `264c0502-9136-4cfc-938b-390b97b861b8/` (Shuffle org runtime data, non-secret).
- E2-risk — Any container with the bind mount can read the credential file; the directory is read-write, so a compromised/buggy action could also write it. Over-broad vs. least-privilege.
- E3-apps — `data/shuffle/apps/` (SHUFFLE_APP_HOTLOAD_FOLDER) is a SEPARATE mount and not in scope.
- E4-narrowing — P54 goal: replace directory bind with a service-scoped single-file secret (e.g. `/run/secrets/iris-shuffle.env`) so only the IRIS-consuming execution app reads it.

## Backup / Rollback
N/A for audit.

## Stop conditions
None.

## Limitations
Org subdir contents enumerated at top level only (no descent into org data). No secret value read.

## Verdict rationale
Directory exposure quantified: a single credential file plus org data; confirms over-broad mount and the case for narrowing.
