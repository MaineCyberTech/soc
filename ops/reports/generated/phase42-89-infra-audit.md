# Phase 42 Infrastructure Audit — INFRA-AUD-42-01

**Report ID:** phase42-89-infra-audit
**Phase:** 42
**Title:** Infra Audit — 34 Containers Up (security-onion Exited(0) Stable; TLS Proxy Up; Backend Uptime Post-Restart-Window), Listeners As Designed, Crontab Full Incl. Watchdog Line, Sensor Units Verified via ssh (Masked Unit + Active Timer + Single ens19 Process count=1), Cluster GREEN, IRIS Healthy, Backups Current; INDEXER CONFIG FINDING: disk.threshold_enabled:false at wazuh1.indexer.yml Line 44 (R-DISKBYPASS)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:24:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-89-infra-audit.md`

---

## 1. Containers (docker ps)

34 running. Key rows: `shuffle-backend` **Up 2 hours** (StartedAt 07:49:33Z —
post-restart-window), `shuffle-frontend` Up 2h (07:45:02Z), `shuffle-tls-proxy`
Up 2h (07:51:19Z), `multi-node-wazuh.master-1` Up 9h, indexers/dashboard/IRIS
stack/tenzir/opencanary/portainer all Up 37h–4d.
Exited audit: `security-onion` **Exited (0) 7 hours ago — stable** under
restart=no (R-SO closure holding); remaining exits are swarm short-lived tasks
(shufflehealthcheck 137s, replaced replicas) plus two Created-only leftovers.

## 2. Listeners (ss)

Design-conformant: frontend `127.0.0.1:3001`, backend `127.0.0.1:5001`,
idx1 `127.0.0.1:9200`, dashboard `127.0.0.1:443`, IRIS `127.0.0.1:8443`,
TLS proxy bound to LAN IP `192.168.222.149:3443` only (no wildcard).
LAN-wildcard set unchanged and by-design/disclosed: SSH :22, portainer
8000/9443, opencanary decoys (21/23/1433/3306/8008/9100), wazuh 1515/1514,
netdata :19999 wildcard noted for the watchlist.

## 3. Crontab (full inventory)

15 entries incl.: elastic-snapshot 03:30 daily; config backup 02:30; health-check
04:30; Phase-5 backup block (04:30–06:00 weekly/daily mix); @reboot shuffle
repair (+120s); **repair */15** (now churn-gated); zeek-classa-guardrail */15;
p33-core-alert */15; **p39-iris-delivery-check */15**;
**watchdog line present: `3,18,33,48 * * * * …/p41-monitor-watchdog.sh`**;
tmp pip-cache cleanup 03:00. No unexplained entries.

## 4. Sensor units (via ssh mct-soc-scan)

```
$ systemctl is-enabled suricata.service   → masked
$ systemctl status suricata.service       → Loaded: masked; Active: failed
                                            (stale pre-mask record, 03:53:19Z)
$ systemctl list-timers | grep compact    → suricata-compact-stats.timer
                                            last 09:45:02Z, next +6s (60s cadence)
$ pgrep -af ens19 | wc -l                 → 1   (exact-args production Suricata,
                                            PID 1320331, single instance)
$ df -h /                                 → 57% (65G/118G)
```

Unit-state vs runtime divergence is exactly the documented mask posture
(AGENTS.md scripting note stands).

## 5. Host capacity & services

| Check | Result |
|---|---|
| df / | **84%** (119G/148G, 23G avail) |
| du /tmp | 1.6G of 7.6G tmpfs (21%) — healthy |
| Cluster health | GREEN, 3 nodes, 149 primary / 282 active |
| IRIS | nginx healthy; HTTPS :8443 answers 302→login |
| Backups | iris-db dumps daily through 20260826; phase2-config daily tars through 20260826; agents-backup dir current incl. today's CHG backup |

## 6. INDEXER CONFIG FINDING (R-DISKBYPASS evidence, exact location)

```
$ grep -n "threshold" multi-node/config/wazuh_indexer/wazuh1.indexer.yml
44: cluster.routing.allocation.disk.threshold_enabled: false

mount proof:
docker-compose.yml:109  ./config/wazuh_indexer/wazuh1.indexer.yml:/usr/share/wazuh-indexer/config/opensearch.yml

live confirmation (all 3 nodes):
_nodes/settings?filter_path=nodes.*.settings.cluster.routing.allocation.disk
→ threshold_enabled:"false" ×3

same posture in Shuffle's own search store:
compose/docker-compose.shuffle.yml:100  - cluster.routing.allocation.disk.threshold_enabled=false
```

Consequence: low/high watermark shutdown/relocation behavior is OFF on both
OpenSearch stores; host at 84% has no cluster-side self-protection. Owner
decision tracked as OW-42-01; risk registered R-DISKBYPASS (top-tier).

## 7. Findings ranked

1. **R-DISKBYPASS** (major, disclosed) — §6.
2. Legacy rejection bursts resumed (bounded, ends at rollover) — phase42-91 quantification.
3. netdata :19999 wildcard listener — add to R-HOOKS-LAN watchlist.
4. Two Created-only containers (`tmp-wazuh4`, `opensearch-plugin-src`) — cosmetic debris, no action without owner.
