# DR Restore Lessons Learned (Phase 10)

Date: 2026-08-15

## What worked

1. **Config bundle restore** - unpack + inventory is fast and validates the
   compose/certs tree. Always the first DR test.
2. **IRIS dump full restore** - the 37KB dump restores in seconds to a scratch
   Postgres. Best full-restore validation artifact.
3. **Dump readability** - all backup artifacts (gzip) validated clean; the
   backup pipeline produces restorable outputs.
4. **OpenSearch snapshot read path** - metadata + status via repo API confirms
   restorability without a full cluster spin-up.

## What to improve

1. **VM sizing** - scratch VMs need >= 30G for restore tests (default 3G too small).
2. **Config bundle perms** - root-owned 0600 files need sudo staging.
3. **Full OpenSearch restore** - needs a scratch OpenSearch instance (same version)
   to truly validate; metadata validation is a proxy. Recommend Phase 11: stand up
   a scratch indexer on VM203 and do a real restore of 1-2 indices.
4. **MISP/Greenbone full restores** - MariaDB/Postgres scratch instances were not
   fully exercised (schema-only); Phase 11 can do full restores now that postgres
   is installed on VM203.

## DR test cadence (recommended)

- Monthly: config bundle unpack + IRIS full restore (cheap, fast).
- Quarterly: full MISP restore + Greenbone schema restore.
- Annual: full OpenSearch index restore to scratch cluster.

## No secrets

No secret values printed.
