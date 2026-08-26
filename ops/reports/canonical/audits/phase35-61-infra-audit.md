# Phase 35: Infrastructure Regression Audit

Date: 2026-08-25

## Hosts
- mct-soc-scan: UP 19h30m, load 0.30/0.14/0.10 (low)

## Containers
| Container | Status |
|---|---|
| multi-node-wazuh.master-1 | UP 22h |
| multi-node-wazuh.worker-1 | UP 3d |
| multi-node-wazuh1.indexer-1 | UP 3d |
| multi-node-wazuh2.indexer-1 | UP 3d |
| multi-node-wazuh3.indexer-1 | UP 3d |
| multi-node-wazuh.dashboard-1 | UP 3d |
| shuffle-backend | UP 22h |
| shuffle-frontend | UP 14min |
| shuffle-orborus | UP 22h |
| shuffle-opensearch | UP 3d |
| shuffle-workers | UP 22h |
| iriswebapp_* | UP 3d (healthy) |
| elastiflow | UP 3d |
| flow-relay | UP 22h |
| tenzir-node | UP 22h |
| security-onion | UP 20h (healthy) |
| mct-security-stack-opencanary-1 | UP 22h |

## Timers/cron
- core-alert: */15 * * * * (active)
- shuffle-repair: */15 * * * * (active)
- zeek-classa-guardrail: */15 * * * * (active)
- backup/health/snapshot: daily (active)

## State files
- agent016: HEALTHY
- backup-fresh: HEALTHY
- disk-wm: FAILED (85%)
- release-provenance: HEALTHY
- tmp-health: HEALTHY
- suricata-service (sensor): HEALTHY
- eve-fresh (sensor): HEALTHY

## Wazuh/OpenSearch
- Cluster: GREEN, 274 active shards
- ISM: 14d policy active
- All indices present

## Agent 016
- Active, canary E2E proven
- eve.json + eve-alert.json forwarding active

## Endpoints
- 013 disconnected, 015 disconnected

## PASS — No infrastructure regressions
## No secrets
