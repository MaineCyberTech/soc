# Workload Move Decision Runbook

Decision framework for moving workloads OFF the Wazuh host. Only used if RAM
cannot be added. No moves without operator approval.

## Trigger conditions

- RAM cannot be added to VM 101, AND
- Swap > 3 GiB sustained for 7 days, OR OOM kills observed in dmesg.

## Candidate order

| Priority | Workload | Mem | Destination | Move risk |
|---|---|---|---|---|
| 1 | Shuffle (opensearch/backend/frontend/worker) | ~1.25 GiB | VM103 | medium (webhook wiring) |
| 2 | IRIS (app/worker/db/rabbitmq) | ~0.5 GiB | VM103 | medium (API keys) |
| 3 | Velociraptor | ~0.3 GiB | VM103 | low |

## Decision matrix

| Question | Answer |
|---|---|
| Is RAM addition possible? | If yes -> add RAM, do NOT move |
| Is target VM sized (VM103 has MISP+Greenbone, ~2GB free?)? | Verify before move |
| Can the move be rolled back in < 1h? | Requirement |
| Does the move touch Wazuh data? | Never allowed |

## Move checklist (Shuffle example)

1. Pre-move: snapshot VM103 in PVE.
2. Copy compose + .env to VM103 (0600).
3. Join mct-security network on VM103 (or use bridge).
4. Start stack; shuffle-healthcheck.sh PASS.
5. Update OpenSearch alerting webhook destinations to new URL.
6. Test D2/D3/D5 payloads through the webhook.
7. Rollback: stop on VM103, restart on Wazuh host (original compose preserved).

## Safety

- No automatic moves. All changes documented in ops/reports.
- Wazuh indexers/master/worker NEVER move off the Wazuh host.
- ElastiFlow stays colocated with Wazuh (filebeat dependency).

## Status

- No move performed in Phase 5 (RAM addition recommended instead).
