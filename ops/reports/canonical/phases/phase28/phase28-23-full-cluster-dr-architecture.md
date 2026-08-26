# Phase 28 Full-Cluster DR Architecture

Date: 2026-08-24
Status: **ARCHITECTURE DOCUMENTED** (evidence-backed; no production restore).

## Source cluster (evidence)

| Item | Value |
|---|---|
| Product | wazuh-indexer (OpenSearch) v4.14.7 / OpenSearch 2.19.5.0 (compat string 7.10.2, Lucene 9.12.3) |
| Nodes | 3 (wazuh1-3.indexer), roles dimr; master wazuh3 |
| Plugins | 17 incl. opensearch-security, repository-s3, ISM, CCR, AD, knn, ml, neural-search, observability, sql, alerting, notifications, async-search, geospatial, job-scheduler, performance-analyzer, reports-scheduler |
| Security | opensearch-security active; admin (backend role admin); HTTPS |
| Snapshot repo | FS type at /snapshots (docker volume) - 42 snapshots, latest snap-20260824-1517 (54 indices) |
| Indices | 65 (~21GB); time-series daily indices; **0 data streams**; 21 index templates |
| Aliases | .kibana, .opendistro-ism-*-history-*, elastiflow rollover aliases (flow/metric/path/telemetry_flow), opensearch-ad-plugin-result-* |
| Replicas | indexer defaults; shards 264 active |
| Retention | ISM policies on archives (14d) + states-retention; template-backed |

## Destination requirements (for future recovery/migration)

- Same-major (2.x) wazuh-indexer; minimum index compat 7.0.0; security plugin present.
- Repository reachable (FS/S3) with credentials; S3 region config (nyc3 precedent).
- Capacity >= 21GB + plugin/system indices + headroom; isolation (network, ports, TLS, secrets).
- Global state: exclude by default (include_global_state=false) to avoid overwriting
  destination cluster settings.
- Aliases/data streams: restore with include_aliases=false; re-create rollover aliases
  deliberately (elastiflow + ISM history).
- Security data: restore .opendistro_security only via explicit decision (admin creds).

## Isolation / teardown

- Scratch cluster on isolated network, separate ports, ephemeral secrets; full teardown after.

## No secrets