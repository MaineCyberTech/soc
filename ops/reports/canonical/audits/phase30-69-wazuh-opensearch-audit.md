# Phase 30 Wazuh / OpenSearch Audit

Date: 2026-08-24

## Cluster

- wazuh-indexer 4.14.7 (OpenSearch 2.19.5.0), 3 nodes (dimr), green, 264 shards, 0 unassigned.
- 17 plugins (security, ISM, alerting, AD, sql, knn, ml, neural, observability, notifications,
  CCR, repository-s3, async-search, geospatial, job-scheduler, PA, reports-scheduler).

## Manager / config

- Master + worker (4.14.7); wazuh-analysisd -t clean; running config vs canonical
  (skip-worktree) documented. Guardrail block toggled via ops script.
- Decoders/rules: Zeek Class A rules (122001-003), suricata bridge, sysmon tuning rules.
- Integrations: custom-json-output (Zeek Class A) -> Shuffle webhook (enabled, guardrailed).

## Agents / templates / ISM / snapshots / security

- Fleet 3/3 coverage (013/015 transient, 008 SO down, 014/015/012 active).
- Templates 21 (states-inventory, archives retention, elastiflow, wazuh-main).
- ISM: archives-14d rolling (08-15..18 wave due ~08-29). Snapshots 42.
- Security: admin/kibanaserver/logstash/... users; HTTPS; auth verified (200).

## Findings

- Indexer heap default (no -Xmx) + no container limits (67).
- SO (008) ingest gap while VM down.

## Verdict

- **PASS** (cluster healthy; capacity items backlogged).

## No secrets