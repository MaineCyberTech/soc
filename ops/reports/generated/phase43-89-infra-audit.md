# Phase 43: Infrastructure Audit

**Report ID:** phase43-89-infra-audit.md
**Phase:** 43
**Title:** Phase 43 Infrastructure Audit
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:10:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-89-infra-audit.md`

---

## 1. Container Inventory

| Container | Status | Networks | Ports | Notes |
|-----------|--------|----------|-------|-------|
| multi-node-wazuh.master-1 | Up | mct-security, multi-node_default | 1514, 1515, 55000 | Manager |
| multi-node-wazuh.worker-1 | Up | mct-security, multi-node_default | 1514, 1515 | Worker |
| multi-node-wazuh1.indexer-1 | Up | mct-security | 9200, 9300 | Indexer |
| multi-node-wazuh2.indexer-1 | Up | mct-security | 9200, 9300 | Indexer |
| multi-node-wazuh3.indexer-1 | Up | mct-security | 9200, 9300 | Indexer |
| multi-node-wazuh.dashboard-1 | Up | mct-security, multi-node_default | 443→5601 | Dashboard |
| shuffle-frontend | Up | mct-security, multi-node_default | 127.0.0.1:3001→80 | Frontend (loopback) |
| shuffle-backend | Up | mct-security, multi-node_default | 127.0.0.1:5001 | Backend |
| shuffle-orborus | Up | mct-security | — | Orborus |
| shuffle-workers | Up (replicated) | mct-security | — | Workers |
| shuffle-opensearch | Up | mct-security | 9200 | Shuffle OS |
| shuffle-tls-proxy | Up | mct-security | 192.168.222.149:3443→443 | TLS Proxy |
| security-onion | **Exited (0)** | — | — | Stopped (retired) |
| mct-security-stack-opencanary | Up | mct-security | 21/tcp, 22/tcp, 80/tcp | Honeypot |
| flow-relay | Up | mct-security | — | Relay |
| tenzir-node | Up | mct-security | — | Tenzir |

---

## 2. Listeners

| Port | Service | Binding | TLS |
|------|---------|---------|-----|
| 3001 | Shuffle Frontend | 127.0.0.1 | No (loopback) |
| 3443 | Shuffle TLS Proxy | 192.168.222.149 | Yes (nginx, self-signed) |
| 5001 | Shuffle Backend | 127.0.0.1 | No |
| 9200 | OpenSearch | 127.0.0.1 | Yes (mutual TLS) |
| 443 | Dashboard | 127.0.0.1 | Yes (nginx) |
| 1514/1515 | Wazuh | 0.0.0.0 | Yes (SSL) |
| 55000 | Wazuh API | 127.0.0.1 | Yes |

---

## 3. Cron/Timers

| Schedule | Command | Status |
|----------|---------|--------|
| `*/15 * * * *` | p39-iris-delivery-check.sh | ACTIVE |
| `3,18,33,48 * * * *` | p41-monitor-watchdog.sh | ACTIVE |
| `0 3 * * *` | tmp cleanup (pip-*) | ACTIVE |
| `@reboot` | shuffle-repair-network.sh --apply | ACTIVE (boot) |
| `*/15 * * * *` | shuffle-repair-network.sh --apply | ACTIVE (gated) |
| `*/1 * * * *` | suricata-compact-stats.timer | ACTIVE (systemd) |
| `3,18,33,48 * * * *` | p41-monitor-watchdog.sh | ACTIVE |

---

## 4. Storage

| Mount | Usage | Notes |
|-------|-------|-------|
| `/` | 85% (120G/148G) | Low watermark active (advisory) |
| `/tmp` | 21% (1.6G/7.6G) | Healthy |
| Docker volumes | Various | OpenSearch, Shuffle DB, Wazuh logs |

---

## 5. Findings

| Finding | Severity | Status |
|---------|----------|--------|
| Disk 85% (thresholds advisory) | MEDIUM | R-DISKBYPASS documented |
| Security-onion stopped | LOW | Retired; volumes preserved |
| Shuffle repair churn | RESOLVED | CHURN-CERT-43-01 PASS |
| Single Suricata instance | LOW | Dual-process defect fixed |

---

## 5. Status

**COMPLETE** — Infra audit complete; findings documented.