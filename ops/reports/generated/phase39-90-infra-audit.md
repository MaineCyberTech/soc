# Infra Audit INFRA-39-02

**Report ID:** phase39-90-infra-audit
**Phase:** 39
**Title:** Infra Audit INFRA-39-02 — Containers, Listeners, Cron, Storage, Cluster Health, Endpoints, Backups, Findings
**Date:** 2026-08-25
**Timestamp:** 2026-08-26T00:15:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `ops/reports/generated/phase39-90-infra-audit.md`

---

## 1. Containers (36 running)

| Container | Status | Purpose / note |
|---|---|---|
| shuffle-frontend / backend / orborus / workers | Up 9m–28h | SOAR plane (frontend rebuilt 9m ago during hardening apply) |
| shufflehealthcheck ×2, subflow/http/email/ai/tools replicas | Up 28–37m | Shuffle app images + workflow apps |
| **security-onion** (syslog-ng image) | Up 25h (healthy) | **RETIRED-BUT-RUNNING** — idle: CPU 0.00%, 16.7MiB; kept for log continuity pending retirement decision (§8) |
| tenzir-node | Up 27h | Flow/packet pipeline; CPU 122% (active processing) |
| flow-relay | Up 27h | python:3-alpine relay to tenzir |
| mct-security-stack-opencanary-1 | Up 27h | Deception sensor (source of L12/L10 alerts) |
| multi-node-wazuh.master / worker | Up 2h / 3d | Manager pair (master restarted today w/ config work) |
| multi-node-wazuh{1,2,3}.indexer | Up 3d | Indexer cluster |
| multi-node-wazuh.dashboard, multi-node-nginx-1 | Up 3d | Console + reverse proxy |
| iriswebapp nginx/app/worker/db/rabbitmq | Up 3d (healthy) | DFIR-IRIS stack — exactly 5 containers ✓ |
| shuffle-opensearch | Up 3d | Shuffle datastore |
| elastiflow | Up 3d | Flow collector |
| wazuh-cloudflared | Up 27h | Tunnel: publishes dashboard via CF (local 443 loopback) |
| portainer | Up 3d | Container admin |

## 2. Listeners (post-hardening)

```
127.0.0.1:5001      shuffle backend        loopback-only ✓
192.168.222.149:3001 shuffle frontend     LAN-interface bind (was 0.0.0.0) ✓ hardened this phase; mgmt-LAN only
127.0.0.1:9200      indexer (via nginx)    auth+TLS on loopback path ✓
127.0.0.1:443       cloudflared local side loopback ✓
127.0.0.1:55000     wazuh manager API      loopback ✓
0.0.0.0:1514/1515   agent/event ingestion  required by design
0.0.0.0:22,23,21,3306,1433,9100,8000,8008,19999,15140,5355,9443 …  pre-existing host/deception surface (unchanged)
```

**3001 mgmt-only VERIFIED**: bound to the management interface address, not wildcard; external
unauthorized probe denied in phase39-18 test.

## 3. Cron / Timers

Active crontab: elastic-snapshot 03:30; health-check 04:30; wazuh config backup 02:30;
phase5 backup family (iris-db 04:30, misp 04:35, greenbone Sun 05:15, workflow export Sun 05:45,
freshness 06:15, prune Sun 06:00); shuffle repair @reboot + */15; zeek guardrail */15;
p33-core-alert */15; tmp pip-* cleanup 03:00 daily.
Gap noted: no delivery-check scheduling (recommendation deferred — phase39-94 §4).

## 4. Storage

```
$ df -h /            → 148G total, 119G used, 24G avail, 84%
$ du -sh /opt/mct-security-stack → 7.4G   (ops/ = 7.3G dominates)
$ du -sh /var/lib/docker         → 4.0K apparent (overlay2 subdirs root-restricted; real usage inside 84% figure)
$ du -sh /tmp                    → 1.6G, 10,215 entries, pip-* count 0
```

Disk posture unchanged vs P38 canonical (84%, above low-watermark caution); ISM wave Aug-29 is the
relief event.

## 5. Wazuh/OpenSearch Health

```
cluster_name: wazuh-cluster   status: GREEN   number_of_nodes: 3
wazuh1.indexer disk 84.17% heap 38% | wazuh2.indexer 84.17% heap 74% | wazuh3.indexer 84.17% heap 54%
```

Node disk tracks host disk (single-volume layout). Heap headroom adequate; wazuh2 at 74% warrants
watch only.

## 6. IRIS Stack Health

5/5 containers up (nginx healthy); delivery lane proven by consecutive-deliveries evidence
(phase39-34; fresh counter rerun today: delivered=37).

## 7. Endpoints

`endpoint-count-report.sh` live run: **10 registered, 7 active** (groups: default 4, linux-servers 2,
linux-clients 1, windows-clients 3, mac-clients 1). Exceptions: 013 SAMSUNG offline,
015 Julians-Air flapping (merged.mg perms defect feeding remoted errors), 008 retired-absent.

## 8. Routing State

Manual-API lane certified CONDITIONAL-PASS (phase39-36); production auto-routing pending webhook
enablement (BCK-38-006). No change today.

## 9. Backups

Repos verified earlier today (fs `wazuh-backup` latest snapshot, s3 `do-spaces` latest) plus
on-box dirs: `ops/backups/` (daily iris-db dumps through 20260825, phase2 config tars, shuffle
workflow exports, compose pre-hardening backup), `/opt/wazuh-docker` config backups via cron.

## 10. tmp State

Healthy: no pip-* accumulation (cron active); 1.6G total under watch, no sanctioned cleanup
required this pass.

## 11. Retired-SO Container Recommendation

security-onion consumes ~17MiB and zero CPU — cost is confusion, not resources. Recommendation:
**stop (not remove)** after one final log-drain verification window. Decision DEFERRED to owner per
approval-gated operations; recorded as OW item input for P40.

## 12. Findings (ranked)

| # | Finding | Sev | Action / owner |
|---|---|---|---|
| F1 | Disk 84% single-volume; all nodes co-limited | MED | Hold for Aug-29 wave; capacity decision after relief measured (Infra) |
| F2 | security-onion retired-but-running | LOW | Stop-decision deferred (owner) |
| F3 | merged.mg perm-denied every ~10s in manager logs | MED | One-line perms fix pending endpoint/config owner (BCK-38-012) |
| F4 | wazuh2.indexer heap 74% | WATCH | Monitor at next audit |
| F5 | No delivery-check cron | LOW | Drafted, activation deferred (SOAR ops) |
