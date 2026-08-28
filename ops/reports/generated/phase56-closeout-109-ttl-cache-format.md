# Phase 56 Closeout: TTL Cache Format

UTC: 2026-08-28T00:25:31Z
America/New_York: 2026-08-27 20:25:31 EDT

## Prompt
109-ttl-cache-format — TTL Cache Format (document JSON-string parsing and expiry value).

## Task
Document how the dedup cache stores TTL: the JSON-string cache entry and its parsed expiry value (expiry-epoch), confirming the value is the absolute expiry time used for suppression decisions.

## Evidence
- EB §5: TTL=300s via expiry-epoch (verified expiry) — the cache entry stores an absolute expiry epoch; the workflow parses the JSON-string cache value to obtain it.
- EB §5: genuine closeout rerun verified the expiry-epoch, evidencing correct JSON-string parse + expiry comparison.
- EB §2: no unsafe webhook GET (p56c-no-get-scan = 0).

## Method
GENUINE-RERUN (partial) + CODE-PATH — the expiry-epoch was verified in the closeout rerun (proving JSON-string parse + comparison); the exact cache schema is confirmed by deployed source code path. Not separately re-parsed into raw JSON in closeout (documented honestly).

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
- No trigger-start, filter, or production change — respected.
- No webhook GET health probe — respected.

## Limitations
Raw JSON-string cache bytes were not separately dumped; the parsed expiry-epoch was verified via the genuine rerun (EB §5).

## Verdict
DONE — cache stores an absolute expiry-epoch in a JSON-string entry; parse + comparison verified by the genuine closeout rerun (EB §5).
