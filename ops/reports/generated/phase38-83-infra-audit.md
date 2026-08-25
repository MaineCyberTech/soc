# Phase 38-83: Infrastructure Audit Report

**Report ID:** phase38-83-infra-audit
**Phase:** 38
**Title:** Phase 38-83: Infrastructure Audit Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-83-infra-audit.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-83 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PARTIAL |

**Status:** PARTIAL
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-83-infra-audit.md`
**Retention Class:** LONG

---

## 1. Executive Summary

Container estate is up (37 running) with one policy violation: the retired `security-onion` container is still running (22h, healthy). The P0 finding stands: **Shuffle frontend on `0.0.0.0:3001` with plaintext HTTP** — no TLS, no host firewall restriction observed. Cloudflared tunnel is healthy (4 QUIC connections registered). Storage at **83%** (117G/148G), memory 75% + swap 64%, load ~3.0–3.9 on a 4-vCPU-class host: sustained pressure, no immediate failure.

## 2. Listeners

```
$ ss -tlnp | grep -E ":3001|:5001|:9200|:443|:55000|:1514"
LISTEN 127.0.0.1:55000        ← Wazuh API (localhost-only, correct)
LISTEN 0.0.0.0:3001           ← Shuffle frontend (ALL INTERFACES, no TLS)   [P0]
LISTEN 127.0.0.1:5001         ← Shuffle backend (localhost-only, correct)
LISTEN 0.0.0.0:1514 + :15140  ← Wazuh agent ingest via nginx (expected)
LISTEN 127.0.0.1:443          ← Wazuh dashboard (localhost-bound; external via cloudflared)
LISTEN 127.0.0.1:9200         ← Indexer (localhost-only, correct)
```

Only deviation from expected matrix: 3001 binding scope.

## 3. Container Fleet

`docker ps` highlights (37 running):

| Container | Ports | Status |
|-----------|-------|--------|
| shuffle-frontend | **0.0.0.0:3001→80/tcp**, 443/tcp | Up 5 min (restarted recently) |
| shuffle-backend | 127.0.0.1:5001→5001 | Up 24h |
| shuffle-orborus / workers / subflow/email/http/ai/tools ×12 | internal | Up 24–25h |
| shufflehealthcheck_1-1 ×2 | internal | Up ~25 min (recurring probe containers) |
| wazuh-cloudflared | none (outbound tunnel) | Up 24h |
| mct-security-stack-opencanary-1 | 21,23,1433,3306,8008,9100 → 0.0.0.0 | Up 24h (deception ports intentionally exposed) |
| flow-relay / tenzir-node / elastiflow | internal | Up 24h–3d |
| **security-onion** | 601/tcp,514/udp,6514/tcp | **Up 22h (healthy)** — RETIRED per P31 decision |
| multi-node-wazuh.{master,worker} | 1515,15140,55000(localhost master) | Up 25h/3d |
| multi-node-{nginx,dashboard,indexer ×3} | 1514, 443(localhost), 9200(localhost) | Up 3d |
| iriswebapp stack (6) | 127.0.0.1:8443 | Up 3d (healthy) |
| shuffle-opensearch | internal | Up 3d — **MEM 95.4% of 1.5GB cap** ⚠ |
| portainer | 8000/9443 → 0.0.0.0 | Up 3d |

## 4. Cloudflared Tunnel Status

Logs show healthy registration:
```
INF Registered tunnel connection connIndex=0..3 (ord11/ord12/ewr13, quic)
WRN Your version 2026.7.3 is outdated. We recommend upgrading to 2026.8.2
```
Tunnel operational (4 connections). Minor: binary outdated — schedule upgrade in maintenance window.

## 5. Host Resources

```
$ df -h   → /dev/sda1: 148G total, 117G used, 25G avail, 83%
$ free -m → Mem 15553 total / 11736 used (75%), swap 8191/5319 (64%)
$ uptime  → load average 3.87, 2.99, 2.60; up 3d16h
$ systemctl list-timers (8): dpkg-db-backup, exim4-base, apt-daily,
  man-db, systemd-tmpfiles-clean (Wed 04:54), apt-daily-upgrade,
  e2scrub_all, fstrim
```

## 6. Cron Inventory (root)

Daily: elastic-snapshot 03:30, health-check 04:30, backup-wazuh-config 02:30, `/tmp` pip cleanup 03:00 (pending first run), misp-db-dump 04:35, phase5-freshness 06:15.
Weekly: greenbone backup Sun 05:15, prune-phase5-backups Sun 06:00, shuffle-workflow-export Sun 05:45.
Every 15 min: shuffle-repair-network, zeek-classa-guardrail check, p33-core-alert.
Observation: snapshot cron writes to fs repo AND s3 repo both current (see phase38-79 §6).

## 7. Storage Detail

Root FS 83%. Major consumers: indexer volumes (274 shards, ≈21GB indices incl replicas across nodes), docker overlay/images, backups under `/opt/mct-security-stack/ops/backups`. Archive retention first relief due 2026-08-29 (~1.8 GB) — see phase38-79.

## 8. Backup Directory Inventory

`/opt/mct-security-stack/ops/backups/`:
- IRIS DB dumps: daily `iris-db-20260812…20260825.sql.gz` (14 consecutive days — unbroken chain)
- Credential files: `iris-admin-pw.txt`, `iris-api-key.txt`, `misp-api-key.txt` — all mode **600** (verified; contents NOT read)
- Config archives: phase2-config tarballs 08-10→08-25 daily
- Workflow exports: `shuffle-workflows/shuffle-workflows-*.json` (latest 08-23) — ⚠ each contains 1 bearer reference (see phase38-84 §6)
- Rollback kit: `p29-image-pin-rollback/`, manager/decoder/rule `.bak` files
- VM103 set: vm103 dir + related scripts

`/opt/wazuh-docker/multi-node/ops/backups/`: compose bak (08-10), local_rules/local_decoder bak (08-17), pw-rotation dirs (08-07).

## 9. Findings & Disposition

| # | Finding | Sev | Disposition |
|---|---------|-----|-------------|
| F1 | Shuffle 3001 on 0.0.0.0, plaintext HTTP, no firewall | **P0** | Bind 127.0.0.1 or iptables restrict + TLS proxy (phase38-73 steps deferred — EXECUTE) |
| F2 | security-onion container still running despite retirement | P2 | Stop+disable compose service; keep image for rollback evidence |
| F3 | shuffle-opensearch at 95.4% of its 1.5 GB heap cap | P2 | Raise limit or cap workflow history retention |
| F4 | Disk 83%, watermark proximity | P2 | Confirm first ISM deletion lands 08-29; else expand volume |
| F5 | cloudflared outdated (2026.7.3) | P3 | Upgrade in window |
| F6 | portainer 8000/9443 on 0.0.0.0 | P3 | Verify management-plane ACL intent |

---
*Evidence captured 2026-08-25 21:00–21:17 UTC.*
