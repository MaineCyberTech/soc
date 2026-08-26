# Phase 37 — Infrastructure Audit

**Timestamp:** 2026-08-25T19:30Z
**Report ID:** P37-67
**Classification:** Internal

---

## Host

| Property | Value |
|----------|-------|
| OS | Linux |
| RAM | 16GB |
| Disk | 148GB (single partition) |
| Disk Usage | 84% (119G/148G) — LOW WATERMARK ACTIVE |

## Containers (Docker Swarm)

| Stack | Containers | Status |
|-------|-----------|--------|
| Wazuh | wazuh-manager, wazuh-indexer, wazuh-dashboard | Running |
| Shuffle | shuffle-frontend, shuffle-backend, shuffle-opensearch | Running |
| IRIS | iris-web | Running |
| Portainer | portainer | Running |
| Cloudflared | cloudflared | Running |

## Network Exposure

| Service | Bind Address | TLS | Status |
|---------|-------------|-----|--------|
| Shuffle Frontend | 0.0.0.0:3001 | No | HARDENING PENDING |
| Wazuh Dashboard | 127.0.0.1:443 | Yes | OK |
| Shuffle Backend | 127.0.0.1:5001 | No | Internal only |

## Firewall

- No host-level firewall configured for Shuffle ports
- Wazuh dashboard restricted to localhost
- Shuffle frontend exposed to all interfaces

## TLS

- Wazuh dashboard: TLS enabled
- Shuffle: no TLS configured

## Timers and Cron

| Schedule | Task | Time (UTC) |
|----------|------|------------|
| backup | Daily backup | 02:30 |
| snapshot | Daily snapshot | 03:30 |
| healthcheck | Daily health check | 04:30 |
| tmp cleanup | /tmp cleanup | 03:00 |

## Docker Networks

| Network | Purpose |
|---------|---------|
| mct-security | Primary security stack |
| multi-node_default | Multi-node Wazuh cluster |
| shuffle_swarm_executions | Shuffle workflow executions |

## Storage

- Single partition layout
- No separate volumes for data persistence
- Disk at 84% with LOW WATERMARK ACTIVE

## Wazuh Cluster

- 3-node cluster (GREEN)
- 274 shards, 100% assigned
- Cluster health: GREEN

## Shuffle Stack

- Frontend: 0.0.0.0:3001
- Backend: 127.0.0.1:5001
- 2 workflows configured
- 796 healthcheck executions

## Endpoints

- 10 registered endpoints
- 7 active, 3 disconnected (008-retired, 013, 015)

## Routing

- No production routing configured
- Workflow-based routing deferred

## Backups

- Daily backup cron active (02:30 UTC)
- Snapshot cron active (03:30 UTC)

## Retired SO

- SO node decommissioned
- Release v1.3.0 marked as RETIRED

## No secrets
