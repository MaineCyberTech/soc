# Phase 17 NetFlow / ElastiFlow Deep Dive

Date: 2026-08-16

## Status: VOLUME + SCOPE FINDINGS - tuning backlog created

## Data

| Metric | Value |
|---|---|
| Flow index | elastiflow-flow-ecs-8.0-2.5-rollover-000001-clean |
| Docs | 4.9M total (1.4GB index) |
| Collector | 192.168.222.149 (Wazuh host) |
| Distinct source IPs | **1,727** |
| Client-network devices | 192.168.111.162 (014), .106, .174, .118, .56 |

## Key findings

1. **Collector scope**: 1,727 source IPs across 20+ subnets (192.168.1.x-15.x,
   192.168.111.x client, 192.168.192.x, 10.10.202.x, 10.11.12.x, public IPs).
   This is far beyond lab (222.x) + client (111.x) - the collector receives
   from multiple gateways/networks.
2. **Client gateways present**: client devices (.111.x) flow through .149,
   talking to 8.8.8.8/1.1.1.1 (normal internet).
3. **Top talkers**: .111.162 (014, 203k), .169.45 (168k), .111.106 (131k),
   104.198.46.246 (97k) - heavy volume from client + other networks.
4. **Flow-relay -> Wazuh 15140**: flow-relay container exists (python:3-alpine)
   but only 8 flow-related alerts in 24h - relay forwarding minimal/none.

## Recommendations

1. Confirm intended collector scope (is .149 supposed to receive 20+ subnets?
   verify netflow export config on gateways).
2. Flow retention: 1.4GB/4.9M docs - rollover + ILM needed (backlog).
3. Flow alerting: only 8 flow-related alerts/24h - consider alerts for
   new-subnet discovery, gateway changes, high-volume talkers.
4. Dashboard: build flow overview (top talkers, subnets, gateway map).

## Backlog

- integrations/elastiflow/phase17-flow-tuning-backlog.md (created)

## No secrets

No secret values printed.
