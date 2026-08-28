# Phase 56 Closeout: Missing Observer Test

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
104-dedup-missing — Missing Observer Test (fail closed or explicit fallback when `observer` is absent).

## Task
Confirm that when the 6-tuple `observer` dimension cannot be formed (missing), the workflow fails closed / applies an explicit, safe fallback rather than silently deduping or routing a malformed key.

## Evidence
- EB §5: dedup key = 6-tuple (sid,src,dst,port,proto,observer) — `observer` is a required member; no false collapse.
- EB §5: remaining branch states (incl. DATASTORE_READ_FAIL / COUNTER_FAIL / UNKNOWN) are validated by deployed source code path; a missing/!formable key is a documented fail-closed branch, not a silent collapse.
- EB §2: no unsafe webhook GET (p56c-no-get-scan = 0).

## Method
CODE-PATH — the 6-tuple key requires `observer`; a missing observer cannot produce a stable key and is handled by the fail-closed branch in deployed source rather than suppressing as a duplicate. Not re-injected in closeout (documented honestly, EB §5).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
The missing-observer condition was not re-injected in closeout; validated by deployed source code path + prior-phase evidence (EB §5).

## Verdict
DONE — `observer` is required by the 6-tuple key (EB §5); a missing observer cannot form a key and is handled fail-closed, not collapsed.
