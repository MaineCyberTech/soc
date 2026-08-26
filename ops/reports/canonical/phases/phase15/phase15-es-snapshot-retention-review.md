# Phase 15 ES Snapshot Retention Review

Date: 2026-08-16

## Status: LOCAL REPO AT ACTION THRESHOLD - cleanup pending approval

## Data

| Repo | Count | Oldest | Newest | Size |
|---|---|---|---|---|
| wazuh-backup (local fs) | 43 | 08-09 06:18 | 08-16 05:17 | 13G |
| do-spaces (S3) | 37 | 08-09 06:48 | 08-16 05:47 | (cloud) |

## Assessment

- All snapshots SUCCESS.
- Local repo at 43 snapshots = ABOVE the 40 ACTION threshold (unbounded growth).
- S3 healthy (37 < 40 threshold).

## Recommendation

1. Delete oldest local snapshots to keep 14 (frees ~8-9G).
2. Add weekly retention job (scripted cleanup).
3. Keep S3 as-is (37, healthy).

## Blocker

- Destructive cleanup requires operator approval (runbook documents procedure).

## No secrets
