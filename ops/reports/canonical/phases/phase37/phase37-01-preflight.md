# Phase 37 — Preflight Report

**Date:** 2026-08-25T19:28Z  
**Cluster:** GREEN (3 nodes, 274 shards, 100%)

---

## Health Summary

| Component | Status | Detail |
|-----------|--------|--------|
| OpenSearch cluster | GREEN | 3 nodes, 274 shards, 100% assigned |
| Wazuh manager | Active | analysisd PID 66961, restarted 19:10Z |
| Shuffle frontend | Up | 0.0.0.0:3001 |
| Shuffle backend | Up | 127.0.0.1:5001 |
| Packet sensor (016) | Active | 1,095 alerts today |

---

## Disk

| Metric | Value | Threshold |
|--------|-------|-----------|
| Used | 119G / 148G (84%) | LOW WATERMARK ACTIVE |
| Available | 24G | |
| /tmp | 1.6G / 7.6G (21%) | Cron cleanup 03:00 UTC daily |

---

## Memory

| Metric | Value |
|--------|-------|
| Total | 15,553 MB |
| Used | 11,747 MB (75%) |
| Available | 3,806 MB |
| Swap used | 5,205 / 8,191 MB (64%) |

---

## Wazuh Agents

| ID | Name | Status |
|----|------|--------|
| 000 | wazuh.master | Active/Local |
| 006 | docker-host | Active |
| 007 | mct-portal-dev | Active |
| 008 | securityonion | Disconnected/RETIRED |
| 011 | mct-linux-client01 | Active |
| 012 | MCT-WIN11PILOT | Active |
| 013 | SAMSUNG | Disconnected |
| 014 | DESKTOP-MI54LFT | Active |
| 015 | Julians-Air | Disconnected |
| 016 | mct-packet-sensor | Active |

**Summary:** 7 Active, 3 Disconnected (1 RETIRED)

---

## Wazuh analysisd Settings

| Setting | Value | Source |
|---------|-------|--------|
| decoder_order_size | 512 | local_internal_options.conf |
| PID | 66961 | |
| Last restart | 19:10Z | |

### "Too many fields" Errors

| Period | Count |
|--------|-------|
| Total | 18,849 |
| Before restart (hour 18) | 10,980 |
| After restart (19:10–19:28) | 1,830 |
| **Accumulation rate** | **Still accumulating** |

**Finding:** 512 is NOT sufficient. Errors continue post-restart.

---

## Shuffle

### Listener Inventory

| Component | Bind | Port | TLS | Auth |
|-----------|------|------|-----|------|
| Frontend | 0.0.0.0 | 3001 | No | No |
| Backend | 127.0.0.1 | 5001 | No | Bearer token |

### Workflows

| Workflow | ID | Trigger | Status | Executions |
|----------|----|---------|--------|------------|
| wazuh-high-severity-to-iris | eb937a37 | Webhook (status=test) | test | 796 |
| wazuh-flow-classb-to-iris | e951db98 | None | draft | 0 |

### Auth
- Bearer token authentication functional
- Admin credential: rotated (P@ssw0rd@), operator rotation pending

---

## ISM / Indices

| Metric | Value |
|--------|-------|
| Managed indices | 53 |
| Archive indices | 11 (wazuh-archives-14d, state=hot, step=condition_not_met) |
| Oldest archive | 10.8 days |
| Alert retention | wazuh-retention (30d) |
| ElastiFlow rollover | FAILED (naming mismatch) |

---

## Alerts

| Source | Count (today) | Detail |
|--------|---------------|--------|
| Agent 016 | 1,095 | Rule 86601 (Suricata), eve-alert.json active |

---

## Endpoints

| Agent | OS | Status |
|-------|----|--------|
| 000 | Linux (manager) | Active/Local |
| 006 | Linux (Docker) | Active |
| 007 | Linux | Active |
| 008 | Linux (SO) | Disconnected/RETIRED |
| 011 | Linux | Active |
| 012 | Windows 11 | Active |
| 013 | Unknown | Disconnected |
| 014 | Windows | Active |
| 015 | macOS (Julian) | Disconnected |
| 016 | Linux (sensor) | Active |

---

## Dashboards

No dashboard changes applied this phase.

---

## Git State

| Field | Value |
|-------|-------|
| HEAD | b7c2f18 |
| Working tree | Clean |
| Release | v1.3.0 |

---

## Blockers

1. analysisd decoder_order_size=512 insufficient — errors accumulating
2. Shuffle port 3001 exposed on all interfaces — no firewall, no TLS
3. Shuffle operator credential rotation pending
4. ElastiFlow rollover naming mismatch
5. No Wazuh → Shuffle webhook configured

---

## No secrets
