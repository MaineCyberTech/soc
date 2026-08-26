# Phase 28 Install Order and Service Graph

Date: 2026-08-24
Status: **ADDED** (config/service-graph.json, machine-readable).

## Graph (DAG)

- infra -> docker -> (stage 1) wazuh-indexer -> (stage 2) wazuh-manager,
  wazuh-dashboard, elastiflow -> (stage 3) iris, shuffle -> (stage 4)
  wazuh-integration, opencanary, security-onion-bridge, tenzir -> (stage 5)
  guardrail-cron, backup-bundle, endpoints.
- Readiness gates per node (cluster green, analysisd -t rc=0, https 9443, etc.).
- Parallel-safe: dashboard/elastiflow with manager; opencanary/bridge/tenzir independent.

## Outputs

- config/service-graph.json (source) - consumed by fresh-target gate + golden-path runbook.

## Design notes

- Swarm Shuffle listed separately (overlay networks) from compose projects; install must
  init swarm before shuffle stack.

## No secrets