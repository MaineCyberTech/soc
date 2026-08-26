# Phase 30 Data, Storage, and Retention Audit

Date: 2026-08-24

## Indices / volumes / growth

- 65 indices / ~21GB (alerts 30d, archives 14d, states-inventory ~30d, elastiflow 14d,
  vulnerabilities). 42 snapshots (rolling 7d) + S3 bundle.
- Volumes: ~40 (indexer-data-1/2/3, iris-web_*, shuffle-database, wazuh config/logs,
  elastiflow-data, opencanary-logs, portainer).
- Disk: root 82%; daily growth collapsed ~100MB. Next archive delete wave 08-15..18
  (~7.4GB) due ~08-29..09-01 (48h from now).

## ISM / snapshots / backup

- ISM policies active (wazuh-archives-14d on all archives indices). Snapshots 42, latest
  SUCCESS. Backup bundle 04:00 + S3 mirror (nyc3). DR bundle verified.

## Migration / recovery

- Component restore drills PASSED (config/single/multi-index); full-cluster NO-GO (no
  target); RTO/RPO by scope (full-cluster UNCLAIMED).

## Deletion / evidence

- No destructive cleanup; snapshot repo API-only; evidence preserved (reports).

## Verdict

- **PASS** (retention rolling; capacity managed; wave due within 2 days - watch 88).

## No secrets