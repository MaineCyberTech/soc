# Phase 43 Closeout: Infrastructure Audit

**Report ID:** phase43-closeout-51-infra-audit
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Infrastructure Audit
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:40:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-51-infra-audit.md`

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
| shuffle-frontend | Up | mct-security, multi-node_default | 127.0.0.1:3001 | Frontend (loopback) |
| shuffle-backend | Up | mct-security, multi-node_default | 127.0.0.1:5001 | Backend |
| shuffle-orborus | Up | mct-security | — | Orborus |
| shuffle-workers | Up (replicated) | mct-security | — | Workers |
| shuffle-opensearch | Up | mct-security | 9200 | Shuffle OS |
| shuffle-tls-proxy | Up | mct-security | 192.168.222.149:3443→443 | TLS Proxy |
| security-onion | **Exited (0)** | — | — | Stopped (retired) |
| mct-security-stack-opencanary | Up | mct-security | 21, 22, 80/tcp | Honeypot |
| flow-relay | Up | mct-security | — | Relay |
| tenzir-node | Up | mct-security | — | Tenzir |

---

## 2. Listeners

| Port | Service | Binding | TLS |
|------|---------|---------|-----|
| 3001 | Shuffle Frontend | 127.0.0.1 | No |
| 3443 | Shuffle TLS Proxy | 192.168.222.149 | Yes (nginx) |
| 5001 | Shuffle Backend | 127.0.0.1 | No |
| 9200 | OpenSearch | 127.0.0.1 | Yes (mutual TLS) |
| 443 | Dashboard | 127.0.0.1 | Yes |
| 1514/1515 | Wazuh | 0.0.0.0 | Yes |
| 55000 | Wazuh API | 127.0.0.1 | Yes |

---

## 3. Network Attachments (P42 Fix)

| Container | Networks | Note |
|---------|----------|------|
| multi-node-wazuh.master-1 | mct-security, multi-node_default | + mct-security (P42 fix) |
| multi-node-wazuh.worker-1 | mct-security, multi-node_default | + mct-security (P42 fix) |
| shuffle-backend | mct-security | — |
| shuffle-tls-proxy | mct-security | — |

---

## 4. Storage

| Mount | Usage | Notes |
|-------|-------|-------|
| `/` | 86% (121G/148G) | Low watermark active (advisory) |
| `/tmp` | 21% (1.6G/7.6G) | Healthy |
| Docker volumes | Various | OpenSearch, Shuffle DB, Wazuh logs |

---

## 5. Findings

| Finding | Severity | Status |
|---------|----------|--------|
| Disk 86% (thresholds advisory) | MEDIUM | R-DISKBYPASS |
| Security-onion stopped | LOW | Retired; volumes preserved |
| Shuffle repair churn | RESOLVED | CHURN-CERT-43-01 PASS |
| Cluster health | GREEN | 3 nodes, 274 shards |

---

## 5. Status

**COMPLETE** — Infra audit complete; findings documented.