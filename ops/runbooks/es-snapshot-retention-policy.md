# ES Snapshot Retention Policy

Date: 2026-08-16 (Phase 15)

## Goals

- Fast local restore: keep recent local snapshots.
- Durable DR: keep S3 snapshots.
- Control local repo growth (currently 13G / 43 snapshots - unbounded).

## Policy

| Repo | Keep | Rotation |
|---|---|---|
| wazuh-backup (local fs) | 14 most recent | delete older on each new snapshot (or weekly job) |
| do-spaces (S3) | 30 most recent | delete older (config bundle restored per DR runbook) |

## Thresholds

| Metric | WARN | ACTION |
|---|---|---|
| Local repo size | 15G | 20G |
| Local snapshot count | 30 | 40 |
| S3 snapshot count | 40 | 50 |

## Rotation procedure (manual for now - no ILM for fs snapshots)

```bash
# List + delete oldest local snapshots (keep 14)
# (requires indexer access - see es-snapshot-retention-report.sh for inventory)

# Example (review first):
# curl -sk -u admin:$PASS -X DELETE https://127.0.0.1:9200/_snapshot/wazuh-backup/snap-XXXX
```

## Rules

- Never delete S3 snapshots without DR review.
- Verify a fresh snapshot exists after any cleanup.
- Run report first: ops/scripts/es-snapshot-retention-report.sh.

## Status (2026-08-16)

- Local: 43 snapshots / 13G - **AT ACTION THRESHOLD (40)** - cleanup pending.
- S3: 37 snapshots - below threshold, healthy.
- Cleanup requires operator approval (destructive).

## No secrets

No secret values printed.
