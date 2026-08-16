# Workload Placement Runbook

Purpose: decide where each workload runs as the stack grows. No moves without operator approval.

## Current placement

| Workload | Host | Memory |
|---|---|---|
| Wazuh (3 indexers + master + worker + dashboard) | Wazuh host (9.3 GiB) | ~5.0 GiB |
| ElastiFlow + flow-relay | Wazuh host | ~0.7 GiB |
| Shuffle (opensearch/backend/frontend/worker) | Wazuh host | ~1.3 GiB |
| IRIS (app/worker/db/rabbitmq/nginx) | Wazuh host | ~0.5 GiB |
| OpenCanary | Wazuh host | <0.1 GiB |
| Velociraptor | Wazuh host | ~0.3 GiB |
| MISP + Greenbone | VM103 (192.168.222.154) | separate |

## Decision rules

1. Wazuh stack + ElastiFlow stay together (data locality, filebeat).
2. Move candidate workloads to VM103 in this order: Shuffle -> IRIS -> Velociraptor.
3. A workload moves only when: host RAM < 15% available OR swap > 30% used,
   AND approval granted, AND a restore/rollback path exists.
4. New client workloads (Sysmon pilot, client canaries) go to dedicated VMs, not the Wazuh host.

## Move procedure (Shuffle as example)

1. Snapshot VM103 (PVE backup) or create target VM.
2. Copy compose file + .env (secrets via 0600 file).
3. Join target to `mct-security` network (create network on VM103 or use host network).
4. Start stack; run shuffle-healthcheck.sh; test webhook.
5. Update OpenSearch alerting destinations (webhook URL hostname).
6. Rollback: stop on VM103, restart on Wazuh host from original compose.

## Monitoring

- resource-trend-report.sh weekly.
- If swap > 4 GiB sustained: escalate placement review.

## Safety

- No automatic moves. All changes manual + documented in ops/reports.
- Never move Wazuh indexers off the Wazuh host without a full DR plan.
