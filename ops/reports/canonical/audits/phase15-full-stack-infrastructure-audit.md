# Phase 15 Full Stack Infrastructure Audit

Date: 2026-08-16

## Status: ALL COMPONENTS OPERATIONAL (1 watch item)

## Component health matrix

| Component | Status | Evidence |
|---|---|---|
| Wazuh manager (master) | HEALTHY | active, rule errors 0 |
| Wazuh worker | HEALTHY | active, rule errors 0, custom_rules loaded |
| Wazuh cluster | HEALTHY | enabled=yes, running=yes |
| OpenSearch indexer (3 nodes) | HEALTHY | green, 196 active shards |
| Wazuh dashboard | HEALTHY | running |
| Agents (7) | HEALTHY | all Active (6 internal + 013 client) |
| Security Onion (agent 008) | HEALTHY | zeek-forward active, fresh ZEEK lines (client subnet traffic visible) |
| ElastiFlow | HEALTHY | 10,000+ flows/24h |
| OpenCanary | HEALTHY | container up; last alert 2026-08-15 23:25 (rule 121012); idle today (no hits = OK) |
| Shuffle | HEALTHY | 13 containers (backend/frontend/workers/ai/subflows) |
| DFIR-IRIS | HEALTHY | 5 containers (app/worker/nginx/db) |
| MISP | HEALTHY | on VM103 (misp-core + nginx) |
| Greenbone | HEALTHY | on VM103 (gvmd/ospd/gsa + feeds); scheduled proof a2020145 |
| Velociraptor | HEALTHY (native) | server binary frontend on :8002 + GUI :8889; client process active; NOTE: runs as native binary, not container (compose exists but unused) |
| Proxmox lab .222 | HEALTHY | 5 VMs running, pool 87.84% |

## Integration health

| Path | Status |
|---|---|
| SO zeek/suricata -> agent 008 -> Wazuh | WORKING (fresh ZEEK lines, .111 client subnet visible) |
| Syslog 15140 (remote) | VERIFIED (P12 CI) |
| Canary 121012/121007/121014 -> alerts | WORKING (last hit 08-15 23:25) |
| Greenbone >=9.0 -> Shuffle -> IRIS | READY (no critical to fire yet - correct) |
| Wazuh -> MISP IOC | integration docs present |
| Level.io -> endpoint deploy | WORKING (013 deployed) |
| Backup cron (config) | WORKING (146KB valid) |
| ES snapshots (S3) | WORKING (37 SUCCESS, latest 05:47) |

## Findings

1. **Velociraptor runs native (not container)** - compose/docker-compose.velociraptor.yml
   is unused/duplicated. Document as source-of-truth: native binary.
2. OpenCanary had 0 hits in last 24h (expected - no triggers; watch).
3. agent 013 on worker01 (all remote agents) - suppression rules present both
   nodes (P14 fix).

## Architecture risk register

- ops/reports/phase15-architecture-risk-register.md (created)

## No secrets

No secret values printed.
