# ES Snapshot Retention Report - 20260816-070451

## Repo: wazuh-backup
  snapshots: 43
  oldest: snap-20260809-0618 2026-08-09T06:18
  newest: snap-20260816-0517 2026-08-16T05:17
  states: {'SUCCESS': 43}
## Repo: do-spaces
  snapshots: 37
  oldest: s3-snap-20260809-0648 2026-08-09T06:48
  newest: s3-snap-20260816-0547 2026-08-16T05:47
  states: {'SUCCESS': 37}

## Local repo disk
13G	/opt/wazuh-backups/elasticsearch

## Policy
- Local: keep 14 snapshots (rolling), then delete oldest.
- S3: keep 30 snapshots (rolling); config bundle per DR runbook.
- Review before destructive cleanup.
