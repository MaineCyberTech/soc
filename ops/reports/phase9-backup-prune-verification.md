# Phase 9 Backup Prune Verification

Date: 2026-08-15

## Prune behavior (last run 2026-08-12)

| Pattern | Retention | Kept | Pruned |
|---|---|---|---|
| iris-db-*.sql.gz | 14d | 3 | 0 |
| misp-db-*.sql.gz | 14d | 2 | 0 |
| greenbone-gvmd-*.sql.gz | 35d | 1 | 0 |
| shuffle-workflows-*.json | 56d | 2 | 0 |

Result: "Done (applied)" - retention respected; nothing pruned because all
archives are within retention (recent setup).

## On-disk counts (2026-08-15)

- IRIS dumps: 7
- MISP dumps: 6
- Shuffle exports: 3
- Greenbone dumps: 1
- OpenSearch local snapshots: 41 (7d retention, every 5h)
- S3 snapshots: 34 (30d retention)

## Assessment

- Prune runs weekly (Sunday 06:00) with --apply and correct retention windows.
- Local snapshot retention (7d) enforced by elastic-snapshot.sh.
- S3 retention (30d) enforced by elastic-snapshot-s3.sh.
- No deletion performed during Phase 9 (safety rule).

## No secrets

No secret values printed.
