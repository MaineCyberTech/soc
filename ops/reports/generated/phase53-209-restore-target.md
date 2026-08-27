# Phase 53: Restore Target

**Prompt:** 209-restore-target
**Generated (UTC):** 2026-08-27T20:09:03Z
**Operator (EDT):** 2026-08-27T16:09:03-0400
**Verdict:** DONE

## Summary
Analysis of the restore target: identify and confirm the authoritative rollback/restore basis.
This is a read-only analysis (per batch gate policy: 209-restore-target is analysis => DONE).
The restore basis is two-fold: (1) the byte-level rollback volume created during the P53
rebuild, and (2) the full logical dump of all OpenSearch indices taken during that same
rebuild.

## Evidence
- E1: Byte-level rollback volume `shuffle-database-rollback-20260827-191004Z` exists
  (docker volume, driver local, mountpoint
  `/var/lib/docker/volumes/shuffle-database-rollback-20260827-191004Z/_data`), 144.1 MB,
  copied from `mct-security-stack_shuffle-database` while OpenSearch was stopped (consistent).
  Authoritative rollback target per `phase53-shuffle-rebuild.md:38-39`.
- E2: Logical dump — every OpenSearch index dumped via `_search?size=10000` during rebuild
  (per `phase53-shuffle-rebuild.md:34`); the logical export complements the byte-level copy.
- E3: IRIS restore basis also present — nightly logical dumps `ops/backups/iris-db-*.sql.gz`
  (latest 20260824) for IRIS DB restore.

## Backup / Rollback
Primary rollback = `shuffle-database-rollback-20260827-191004Z` (byte-level) + the rebuild
logical dump. Rollback procedure (per rebuild report): stop compose, `docker volume rm
mct-security-stack_shuffle-database`, recreate, `cp -a` from the rollback volume, `up -d`.

## Limitations
This report is the *target analysis* only; the actual restore execution is gated (see 219).
External-target adequacy for a full-cluster rehearsal is still owner-pending.

## Verdict rationale
Restore target (byte-level volume + logical dump) identified and verified to exist. Analysis
complete => DONE.
