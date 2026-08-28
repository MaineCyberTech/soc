# Phase 56 Closeout: Secure Auth Plan

**UTC:** 2026-08-28T00:25:31Z
**America/New_York:** 2026-08-27 20:25:31 EDT

## Prompt
Plan replacement of insecure/empty auth with an approved reference for the Class-A IRIS call.

## Task
Define how the IRIS `Authorization` header on workflow `eb937a37` is set from an approved, export-safe reference (no literal secret).

## Evidence
- EB §2: IRIS auth header now set to a valid IRIS key (value-blind; Bearer prefix present). Resolves prior 401.
- EB §9: owner authorization covered the IRIS auth header fix.
- Overlay: "A literal credential in workflow JSON is prohibited." Secure-reference replacement required.

## Method
READ-ONLY-INSPECTION — plan derived from EB; apply step is 048.

## Backup
Workflow `eb937a37` revision preserved via git HEAD c33fcde/92d8bb8 (EB §1).

## Rollback
Revert IRIS auth header to prior (invalid/empty) state only via authorized change; current state is the secure target.

## Stop conditions
Plan would stop before any credential rotation that changes secrets (out of "fix it all" scope per EB §9). Reference by ID/path only.

## Limitations
Plan relies on Shuffle storing the key as a variable/reference rather than inline literal; confirmation of storage mechanism not re-derived in closeout.

## Verdict
DONE — secure-auth plan defined (Bearer IRIS key via approved reference, value-blind); applied and verified in 048.
