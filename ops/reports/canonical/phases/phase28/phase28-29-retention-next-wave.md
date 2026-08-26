# Phase 28 Retention Next Wave

Date: 2026-08-24
Status: **ON SCHEDULE** - next delete wave not yet due.

## State

- Archives present: 08-15..08-24 (08-10 deleted in P27; 08-11..14 absent pre-P22).
- ISM: `wazuh-archives-14d` policy active on all archives indices (state: hot).

## Projected deletions

| Index | Created | 14d birthday (expected delete) |
|---|---|---|
| wazuh-archives-4.x-2026.08.15 | 08-15 | **~08-29** |
| 08-16 | | ~08-30 |
| 08-17 | | ~08-31 |
| 08-18 | | ~09-01 |

- Combined relief ~7.4GB (08-15 1.9GB + 08-16 1.3GB + 08-17 2.5GB + 08-18 2.1GB).

## ISM health

- No policy errors observed; indices moving through hot state normally; history index
  present (.opendistro-ism-managed-index-history-write).

## Next check

- Confirm 08-15 deletion lands on/after 08-29 (phase 30 / monthly ops).

## No secrets