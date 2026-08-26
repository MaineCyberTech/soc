# Phase 28 Dependency Lock Audit

Date: 2026-08-24
Status: **MANIFEST ADDED** (config/dependency-lock.json).

## Coverage

- Images: 14 pinned with tag + image_id_prefix (provenance). Runtime-verified from docker inspect.
- Python: stdlib-only core (3.13.5); optional pins (pymisp/requests/pyyaml) documented.
- OS packages: endpoint installers pin wazuh-agent=$WAZUH_VERSION-1, osquery (apt/yum/dnf branches).
- Plugins: wazuh-indexer plugin set pinned (2.19.5.0).
- Sysmon binary: 15.21 pinned (schema 4.91 independent of binary, per research notes).

## Findings

| Item | Risk | Action |
|---|---|---|
| Mutable tags in prod (shuffle-backend/frontend/orborus/worker `latest`, tenzir `main`, opencanary `latest`, syslog-ng `latest`, flow-relay `python:3-alpine`) | image drift / supply chain | PIN to resolved image IDs in release bundle manifest |
| No full lock file before | reproducibility | dependency-lock.json added (this phase) |
| requirements.txt optional (not pinned to exact) | dev only | keep; core is stdlib-only |

## Compatibility matrix

- wazuh-manager 4.14.7 + indexer 4.14.7 (OpenSearch 2.19.5.0) - matched pair.
- IRIS v2.4.29 image family; rabbitmq 3-management-alpine.
- Restore compat: index min 7.0.0, same-major only (23).

## No secrets