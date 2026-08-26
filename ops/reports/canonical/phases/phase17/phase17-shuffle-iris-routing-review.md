# Phase 17 Shuffle/IRIS Routing and Case Quality Review

Date: 2026-08-16

## Status: ROUTING MAP VERIFIED - containers healthy

## Shuffle

- 8 containers running (backend/frontend/workers/subflows/ai/tools).
- Workflows: wazuh-high-severity-to-iris (Class A), wazuh-flow-classb-to-iris.
- OpenSearch monitors -> Shuffle webhooks: flow-unknown-exporter,
  flow-lateral-movement, opencanary-hit (Class A); flow-unusual-ports,
  flow-icmp-flood, flow-high-outbound-bytes (Class B).
- No workflow executions in 24h - consistent with no high-severity triggers.

## IRIS

- 5 containers healthy (app/worker/nginx/db/rabbitmq).
- Case creation path: Shuffle webhook -> IRIS alert (notify-only Class A).

## Routing quality

- Class A (high-severity) -> IRIS: configured.
- Class B (flow) -> IRIS: configured (flow-classb).
- Noisy/low-value case triggers: none observed (0 executions - clean).
- Fallback/manual: documented (webhook-map-phase5.md).

## Findings

1. No IRIS cases generated in 24h - no qualifying events (correct behavior).
2. Greenbone critical -> IRIS uses wazuh-high-severity trigger (D5 reuse).

## Files

- integrations/dfir-iris/phase17-case-quality-backlog.md (created)
- integrations/shuffle/phase17-workflow-routing-map.md (created)

## No secrets
