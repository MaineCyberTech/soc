# Phase 40 Infrastructure Audit

**Report ID:** phase40-84-infra-audit
**Phase:** 40
**Title:** INFRA-40-02 — Full Runtime Census: 40 Running Containers, security-onion EXITED(0) Confirmed (Volumes Preserved, Restart-Policy Gap Logged), Listener Table With New :3443 TLS + Loopback Rebinds, Cross-Network Attachments Documented, Cluster Green, IRIS Healthy ×5, Backups Fresh, Disk 83%
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-84-infra-audit.md`

---

## 1. Container Fleet (`docker ps` full table, condensed columns)

| Container | Status | Image |
|---|---|---|
| shufflehealthcheck_1-1-0.{1,2} | Up 21 min | frikky/shuffle:shufflehealthcheck_1.1.0 |
| shuffle-frontend | Up 12 min | ghcr.io/shuffle/shuffle-frontend |
| shuffle-tls-proxy | Up 58 min | nginx:1.27-alpine |
| shuffle-backend | Up 23 min | ghcr.io/shuffle/shuffle-backend |
| wazuh-cloudflared | Up 30 h | cloudflare/cloudflared:latest |
| mct-security-stack-opencanary-1 | Up 30 h | thinkst/opencanary |
| flow-relay | Up 30 h | python:3-alpine |
| tenzir-node | Up 30 h | tenzir/tenzir |
| shuffle-workers.1… / orborus | Up 30 h | ghcr.io/shuffle/* |
| shuffle app-apps (subflow/email/ai/http/tools ×2 replicas) | Up 31 h | frikky/shuffle:* / ebebd9c68c69 |
| multi-node-wazuh.master-1 | Up 2 h | wazuh/wazuh-manager:4.14.7 |
| multi-node-wazuh.worker-1 | Up 3 days | wazuh/wazuh-manager:4.14.7 |
| iriswebapp_{nginx,worker,app,db,rabbitmq} | Up 3 days (nginx: healthy) | dfir-iris v2.4.29 / rabbitmq:3-mgmt-alpine |
| shuffle-opensearch | Up 3 days | opensearchproject/opensearch:3.2.0 |
| elastiflow | Up 3 days | elastiflow/flow-collector:7.26.2 |
| multi-node-wazuh{1,2,3}.indexer-1 | Up 3 days | wazuh/wazuh-indexer:4.14.7 |
| portainer | Up 3 days | portainer/portainer-ce:sts |
| multi-node-nginx-1 | Up 3 days | nginx:stable |
| multi-node-wazuh.dashboard-1 | Up 3 days | wazuh/wazuh-dashboard:4.14.7 |

Retired plane:

```
security-onion   Exited (0) 9 minutes ago   ← re-checked via inspect:
State=exited ExitCode=0 FinishedAt=2026-08-26T02:48:09Z RestartPolicy=always
```

STOP decision executed as approved in phase40-81; **stopped-not-removed**.

## 2. Listeners (`ss -tlnp`, full table)

| Address:Port | Process/plane | Note |
|---|---|---|
| 192.168.222.149:3443 | shuffle-tls-proxy | NEW — TLS mgmt plane for Shuffle UI |
| 127.0.0.1:3001 | shuffle-frontend (docker-publish 80→3001) | NEW binding — loopback-rebound this phase |
| 127.0.0.1:5001 | shuffle-backend API | loopback only |
| 127.0.0.1:9200 | indexer via nginx auth+TLS | unchanged |
| 127.0.0.1:443 | cloudflared local side | unchanged |
| 127.0.0.1:55000 | Wazuh manager API | loopback ✓ |
| 127.0.0.1:{8001,8003,8125,8443,8889,4317,25} | local services/metabase/otel/etc | unchanged |
| 0.0.0.0:1514 / 1515 | agent/event + enrollment ingestion | required by design (password-gated) |
| 0.0.0.0:{22,21,23,3306,1433,8000,8008,19999,9100,9443,15140,5355}, *:8080(flowcoll), 33333-33339, 20241, swarm 2377/7946 | pre-existing host/deception surface | unchanged from P39 matrix |

No listener regression vs expected matrix; two intended additions (:3443, :3001-loopback).

## 3. Crontab (root user, full listing)

```
30 3  * * *  elastic-snapshot.sh            → snapshot repo cadence
30 4  * * *  health-check.sh               → stack health log
30 2  * * *  backup-wazuh-config.sh        → config backup
@reboot       sleep 120 && shuffle-repair-network.sh --apply
15 6  * * *  phase5-backup-freshness-check.sh
 0 6  * * 0  prune-phase5-backups.sh --apply
30 4  * * *  iris-db-dump.sh ; 35 4 vm103-misp-db-dump.sh ; 15 5 * *0 greenbone ; 45 5 * *0 shuffle-workflow-export
*/15 * * *   shuffle-repair-network.sh --apply ; zeek-classa-guardrail.sh check ; p33-core-alert.sh
 0 3  * * *  find /tmp -name 'pip-*' -mtime +1 -delete
*/15 * * *   p39-iris-delivery-check.sh      ← NEW delivery monitor (verified firing; log mtime 03:00:01Z today)
```

Three stack-cron families + tmp sweeper + delivery-monitor present as expected.

## 4. Networks Audit (incl. NEW cross-attachments)

`mct-security` members include **multi-node-wazuh.master-1 and multi-node-wazuh.worker-1**
alongside all shuffle containers + iriswebapp_nginx + opencanary.

| Item | Detail |
|---|---|
| Purpose (master) | integratord → `http://shuffle-backend:5001/api/v1/hooks/webhook_eb937a37…` reachability (proven E2E-007) |
| Purpose (worker) | cluster-parity so a failover/promotion keeps the webhook lane functional without mid-incident network surgery |
| Rollback | `docker network disconnect mct-security multi-node-wazuh.{master,worker}-1` (non-persistent across compose recreate of the wazuh stack; re-add documented) |
| Residual | attachment is docker-host-local state, not yet codified in compose override → drift-plane item D-40-x tracked in phase40-90 |

`multi-node_default` retains its canonical 9 members (nginx, master/worker, 3 indexers,
dashboard, frontend, opencanary). Overlay nets for swarm executions intact.

## 5. Storage

```
$ df -h /
/dev/sda1  148G  117G  25G  83%  /
$ du -sh /tmp → 1.6G, entries: 10215 (tmp.* churn files dominate count)
```

Disk at 83% (prompt anchor said 82%; live measurement is authoritative). Post-relief
plateau holding; next ISM deletion wave window opens 2026-08-29.

## 6. Wazuh Cluster

```
$ cluster_control -l (master)
NAME      TYPE    VERSION  ADDRESS
manager   master  4.14.7   wazuh.master
worker01  worker  4.14.7   172.20.0.3
```

Both nodes GREEN on 4.14.7; agent population: 6 active (006,007,011,012,014,016) +
000 local; 013 SAMSUNG and 015 Julians-Air Disconnected (owner-side blockers); 008
securityonion Disconnected (retired).

## 7. IRIS Plane

Five containers Up 3 days: nginx (**healthy**), app, worker, db, rabbitmq. Live DB probe
returned the three synthetic Class-A rows (alerts 40–42) — service healthy end-to-end.

## 8. Backups Repos Fresh Counts

| Repo | Freshest | Cadence evidence |
|---|---|---|
| iris-db dumps | `iris-db-20260825-043001.sql.gz` | daily chain unbroken through Aug 25 (14 dumps listed) |
| AGENTS.md change backups | `.bak-20260826-{014430,024615}` + sha256 sidecars | CHG-40-AGENTS-01 compliant; `sha256sum -c …024615` → **OK** |
| Snapshot repos | fs 42 snaps (~5–6/day), s3 86 snaps (5/day) | per current-state §9 / phase40-70 |

## 9. Retired SecurityOnion State

Exited(0), not removed; image retained; volume `multi-node_security-onion-persist`
(created 2026-08-08T03:18:23Z) intact incl. the ~808 MB static disk-buffer artifact;
read-only config mounts untouched. Rollback remains one command (`docker start security-onion`).

## 10. Findings (ranked)

| # | Sev | Finding | Owner |
|---|---|---|---|
| F-84-01 | MED | SO `RestartPolicy=always` survives host reboot → retired container auto-starts on reboot; set `--restart=no` or remove-at-approval (P41) | Infra owner |
| F-84-02 | LOW | mct-security cross-attachments not codified in compose files → manual re-apply after stack recreate | Platform |
| F-84-03 | INFO | /tmp entry count 10,215 (mostly tmp.* churn); within policy, watch trend | Infra owner |
| F-84-04 | INFO | Disk 83% vs 82% anchor — rounding/measurement-time delta, no action | Infra owner |

## 11. Verdict

**INFRA AUDIT: PASS WITH FINDINGS.** Runtime matches the post-change design intent
(TLS plane live, plaintext UI path closed, SO retired cleanly); two actionable items
logged with owners.
