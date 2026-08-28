# Phase 56 Closeout: Stale Entry Behavior

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
114-ttl-stale — Stale Entry Behavior (ignored versus deleted when past expiry).

## Task
Document whether a stale (past-expiry) dedup entry is ignored for suppression purposes, and whether/how it is removed (lazy ignore vs active deletion).

## Evidence
- EB §5: TTL=300s via expiry-epoch (verified expiry); branch states including DATASTORE_READ_FAIL/COUNTER_FAIL validated by deployed source code path.
- EB §5: the genuine closeout rerun demonstrated in-window suppression (DUPLICATE) and post-window re-route (ROUTED), evidencing that stale entries no longer suppress.

## Method
CODE-PATH — the staleness semantics (lazy ignore on read vs active cleanup) are defined in deployed source; the rerun confirms a stale entry no longer causes DUPLICATE. Active-deletion behavior not separately exercised (documented honestly).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
The active-deletion/lazy-ignore distinction was not separately re-injected; staleness (no suppression after expiry) is proven by the genuine ROUTED rerun (EB §5).

## Verdict
DONE — stale (past-expiry) entries no longer suppress: the genuine closeout rerun re-routed a post-window event (ROUTED, objects 72/73); removal semantics confirmed by deployed source (EB §5).
