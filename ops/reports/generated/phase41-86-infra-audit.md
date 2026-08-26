# Phase 41 Infrastructure Audit

**Report ID:** phase41-86-infra-audit
**Phase:** 41
**Title:** AUDIT-INFRA-41 — 40 Containers Up With Zero Restarts Except Documented Churn, Full Listener Matrix Mapped (Loopback-First Posture Holding), Crontab Reproduced In Full, Sensor Units Verified Live (suricata MASKED + Stale failed State Explained; Compact Timer 60 s Active; Prod Exact-Args Process Single), Cluster GREEN, Backup Repos Fresh (fs 42 / s3 87 Snaps)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:47:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-86-infra-audit.md`

---

## 1. docker ps (condensed table, live)

| Container | Status | Note |
|---|---|---|
| multi-node-wazuh.master-1 | Up 5 h | manager 4.14.7 |
| multi-node-wazuh.worker-1 | Up 4 d | manager 4.14.7 |
| multi-node-wazuh{1,2,3}.indexer-1 | Up 4 d | cluster GREEN |
| multi-node-wazuh.dashboard-1 | Up 4 d | loopback :443→5601 |
| multi-node-nginx-1 | Up 4 d | :1514 ingress |
| shuffle-backend / -frontend / -tls-proxy / -orborus / workers.1 | Up 2 h–34 d | frontend restarted 06:30Z by repair script (see §7) |
| shuffle app containers (http/tools/email/ai/subflow/healthcheck) | Up 34 m–4 d | ephemeral app-sdk family |
| shuffle-opensearch | Up 4 d | 1.44 GiB/1.5 GiB cap |
| iriswebapp_{nginx,app,worker,db,rabbitmq} | Up 4 d (healthy) | IRIS v2.4.29 |
| tenzir-node, elastiflow, flow-relay | Up 4 d | telemetry pipeline |
| mct-security-stack-opencanary-1 | Up 34 h | decoy ports by design |
| portainer | Up 4 d | 0.0.0.0:8000/:9443 — LAN mgmt plane (R-HOOKS-LAN) |
| wazuh-cloudflared | Up 34 h | tunnel |
| security-onion | (not in ps) | retired exited(0), restart=no [phase41-80] |

## 2. Listener matrix (ss -tlnp, deduped)

| Bind | Port | Purpose |
|---|---|---|
| 192.168.222.149 | 3443 | Shuffle TLS proxy (single LAN-pinned bind) |
| 127.0.0.1 | 3001 / 5001 / 8443 / 443 / 55000 / 9200 | frontend / backend / IRIS nginx / dashboard→5601 / manager API / indexer-1 |
| 0.0.0.0 | 1514,1515,15140 | Wazuh ingress (by design) |
| 0.0.0.0 | 21,23,1433,3306,8008,9100 | opencanary decoys (by design) |
| 0.0.0.0 | 8000,9443 | portainer mgmt — residual exposure |
| 0.0.0.0 | 8080 | flowcoll (elastiflow) |
| *:2379/7946/3333x swarm family | — | docker swarm overlay control |

No wildcard Shuffle/UI exposure; plaintext :3001 loopback-only holds.

## 3. crontab -l (FULL, live)

```
30 3 * * * /opt/wazuh-docker/multi-node/ops/scripts/elastic-snapshot.sh >> /tmp/wazuh-snapshot-cron.log 2>&1
30 4 * * * /opt/wazuh-docker/multi-node/ops/scripts/health-check.sh >> /tmp/wazuh-health.log 2>&1
30 2 * * * sudo /opt/wazuh-docker/multi-node/ops/scripts/backup-wazuh-config.sh >> /tmp/wazuh-backup-cron.log 2>&1
@reboot sleep 120 && /opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh --apply >> …/shuffle-boot-repair.log 2>&1
30 4 * * * /opt/mct-security-stack/ops/scripts/iris-db-dump.sh >> …/iris-db-cron.log 2>&1
35 4 * * * /opt/mct-security-stack/ops/scripts/vm103-misp-db-dump.sh >> …/vm103-misp-cron.log 2>&1
15 5 * * 0 /opt/mct-security-stack/ops/scripts/vm103-greenbone-backup.sh >> …/vm103-greenbone-cron.log 2>&1
45 5 * * 0 /opt/mct-security-stack/ops/scripts/shuffle-workflow-export.sh >> …/shuffle-export-cron.log 2>&1
15 6 * * * /opt/mct-security-stack/ops/scripts/phase5-backup-freshness-check.sh >> …
0 6 * * 0 /opt/mct-security-stack/ops/scripts/prune-phase5-backups.sh --apply >> …
*/15 * * * * /opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh --apply >> …
*/15 * * * * /opt/mct-security-stack/ops/scripts/zeek-classa-guardrail.sh check >> …
*/15 * * * * bash /opt/mct-security-stack/ops/scripts/p33-core-alert.sh >> …
0 3 * * * find /tmp -name 'pip-*' -mtime +1 -delete 2>/dev/null
*/15 * * * * /opt/mct-security-stack/ops/scripts/p39-iris-delivery-check.sh >> …/shuffle-delivery-monitor.log 2>&1
# Phase 41 watchdog: alerts if delivery monitor stalls >20min (report phase41-39)
3,18,33,48 * * * * /opt/mct-security-stack/ops/scripts/p41-monitor-watchdog.sh >> …/p41-monitor-watchdog.log 2>&1
```

## 4. SENSOR units (ssh -o BatchMode=yes mct-soc-scan, live)

```
$ systemctl is-enabled suricata            → masked
$ systemctl is-active suricata             → failed   ← STALE pre-mask record, not a live fault:
                                                no unit-managed process exists; prod runs via setsid
$ systemctl is-active suricata-compact-stats.timer → active
$ systemctl list-timers suricata-compact-stats.timer
        NEXT Wed 2026-08-26 06:24:38 UTC · LAST 06:23:38 UTC (60 s cadence confirmed)
$ pgrep -af ens19 →
   1320331 /usr/bin/suricata -c /etc/suricata/suricata.yaml -i ens19 \
           -S /var/lib/suricata/rules/suricata.rules -l /var/log/suricata
   (EXACTLY ONE production process — dual-process defect stays fixed; G41-02/03)
$ df -h / (sensor) → 57% (65G/118G) · wazuh-agent active
```
Unmask procedure (documented only): `systemctl unmask suricata && systemctl daemon-reload`,
then disable exact-args invocation FIRST to avoid re-creating the dual-process defect;
full rollback sequence G41-12 (phase41-15 §7).

## 5. Networks purpose

`multi-node_default` (Wazuh stack), `mct-security` (cross-stack lane: managers+shuffle+IRIS),
`shuffle_swarm_executions` (overlay, worker apps), `iris_frontend/backend`, `tenzir-network`,
`portainer_network`, ingress/gwbridge (swarm control), bridge/host/none defaults.

## 6. Storage & cluster

```
host df: 84% (24G avail) · du backups dir 7.2G · /tmp 1.6G across 10,216 entries
sensor df: 57%
cluster health: green · 3 nodes · 282 shards / 149 primary · 0 unassigned
snapshots: fs wazuh-backup = 42 (latest snap-20260826-0517) · do-spaces = 87 (latest s3-snap-20260826-0547)
IRIS containers: all Up 4 days, healthy
```

## 7. Findings ranked

1. **MED — frontend restart churn**: docker events show kill→stop→die→start at
   06:30:02–03Z; cause identified in code: `shuffle-repair-network.sh` lines 59–61
   restart shuffle-frontend UNCONDITIONALLY on every */15 --apply run (~96/day).
   Tracked OW-41-05 / R-CHURN. Fix: gate on DNS-failure detection.
2. LOW — portainer 0.0.0.0:8000/9443 LAN mgmt plane (R-HOOKS-LAN family).
3. LOW — sensor suricata.service lingers in `failed` state while masked (cosmetic but
   misleading to future auditors; `systemctl reset-failed suricata` candidate).
4. INFO — /tmp 10,216 entries (pip cleanup cron covers pip-* only).
5. PASS — backups fresh, cluster green, listener posture, sensor production single
   process, watchdog cron armed.
