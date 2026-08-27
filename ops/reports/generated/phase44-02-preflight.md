# Phase 44: Phase 44 Preflight

**Report ID:** phase44-02-preflight
**Phase:** 44
**Title:** Phase 44 Preflight
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T22:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-02-preflight.md`

---

## 1. Git & Release State

| Item | Value |
|------|-------|
| Git HEAD | `233e1ab` (Phase 43 Closeout) |
| Git Status | Clean (1 untracked: `STATE_OF_THE_STACK_20260826.md`) |
| Release | v1.3.1 (tag pushed, asset on-box) |
| Previous Tag | v1.3.0 |

---

## 2. Disk & Filesystem

| Metric | Value |
|--------|-------|
| Root Disk | 148G total, 121G used (82%), 21G avail (14%) |
| /tmp | 7.6G total, 1.6G used (21%) |

---

## 3. Memory & Swap

| Metric | Value |
|--------|-------|
| Total RAM | 15.6 GiB |
| Used | 11.1 GiB (71%) |
| Available | 3.9 GiB |
| Swap | 8.0 GiB total, 5.0 GiB used (63%) |

---

## 4. OpenSearch Cluster

| Metric | Value |
|--------|-------|
| Cluster Health | GREEN |
| Nodes | 3 |
| Shards | 274 (100% active) |
| Disk Usage | 86% (121G/148G) |
| **disk.threshold_enabled** | **false** (watermarks advisory only) |

---

## 5. Archive Indices (wazuh-archives-*)

| Index | Created | Size |
|-------|---------|------|
| wazuh-archives-4.x-2026.08.24 | 2026-08-24T00:00:02Z | 69.8 MB |
| wazuh-archives-4.x-2026.08.25 | 2026-08-25T00:00:02Z | 284.8 MB |
| wazuh-archives-4.x-2026.08.26 | 2026-08-26T00:00:02Z | 503.3 MB |
| **wazuh-archives-4.x-2026.08.27** | **NOT YET BORN** | Expected ~00:00:02Z Aug-27 |

> **Critical**: The 2026.08.27 archive index has **NOT been created yet** (expected at ~00:00:02 UTC tonight).

---

## 5. Wazuh Agents

| ID | Name | Status | Last Keepalive |
|----|------|--------|----------------|
| 000 | wazuh.master | active | — |
| 006 | docker-host | active | — |
| 007 | mct-portal-dev | active | — |
| 011 | mct-linux-client01 | active | — |
| 012 | MCT-WIN11PILOT | active | — |
| 013 | SAMSUNG | **disconnected** | >26h offline — owner action |
| 014 | DESKTOP-MI54LFT | active | |
| 015 | Julians-Air | **disconnected** | Flapping (macOS sleep) |
| 008 | securityonion | **stopped** | Retired; container stopped, restart=no |

**Active agents**: 7 (000, 006, 007, 011, 012, 014, 016)
**Disconnected**: 2 (013, 015) — both owner-gated
**Retired**: 1 (008)

---

## 6. Shuffle State

| Component | Status |
|-----------|--------|
| Frontend | `192.168.222.149:3001` (mgmt only) |
| TLS Proxy | `192.168.222.149:3443` (nginx, TLS 1.2/1.3, HSTS/XFO/nosniff) |
| Backend | `127.0.0.1:5001` (loopback) |
| Workflows | 3 (Class-A test, Class-B draft, Packet test) |
| Bearer Token | Rotated (old→401, new→200) |
| Repair Churn | **ELIMINATED** (FRONTEND_REPAIRED gate) |

---

## 8. IRIS & Delivery

| Metric | Value |
|--------|-------|
| IRIS Containers | 5/5 healthy |
| Delivery Monitor | 23+ cycles (14h+), 2 real fail-closed caught |
| Watchdog | Active (cron 3,18,33,48), dedicated alert log |
| Class-A Routing | CERTIFIED-AUTOMATED (68 real deliveries) |
| Packet Lane | DISABLED/TEST-ONLY (platform defect) |

---

## 9. ISM & Retention

| Policy | State | Next Action |
|--------|-------|-------------|
| `wazuh-archives-14d` | Attached to all 12 archives | 08.15 ETA: 2026-08-29T21:00:44Z |
| `wazuh-retention` | On alert indices (30d) | Active |
| Snapshots (fs) | 42 | Latest: 2026-08-26T03:30Z |
| Snapshots (S3) | 87 | Latest: 2026-08-26T00:47Z |
| Restore Spot-Checks | 4× PASS | Latest: 170,521=170,521 parity |

---

## 9. Disk Thresholds

| Setting | Value | Status |
|---------|-------|--------|
| `threshold_enabled` | **false** | Watermarks advisory only |
| Low Watermark | 85% | **EXCEEDED** (86%) — advisory only |
| High Watermark | 90% | 4% away |
| Flood Stage | 95% | 9% away (enforced read-only) |

> **Critical**: `disk.threshold_enabled=false` — watermarks are advisory only. No allocation blocks at 85%.

---

## 10. CI & Governance

| Suite | Status |
|-------|--------|
| p38-report-ci.sh | PASS (0 errors, 0 warnings) |
| p39-canonical-ci.sh | PASS |
| p39-agents-ci.sh | PASS |

---

## 11. Blockers & Open Items

| Item | Status | Blocker |
|------|--------|---------|
| 08.27 Field Adjudication | STAGED | Index not born yet |
| Monitor Full-Day Cert | RUNNING (23+ cycles) | Completes 01:45Z Aug-27 |
| Owner Session (8 items) | PACKAGED | No human available |
| RTO/RPO Signoff | AWAITING-OWNER | DEC-40-01 ready |
| Restore Target | AWAITING-OWNER | Candidate matrix ready |
| Disk Threshold Policy | DECISION NEEDED | Owner decision |
| v1.3.1 GitHub Release | BLOCKED | No GH token |
| Packet Lane | DEFERRED | Platform defect |
| Dashboard v2 Swap | PENDING | Owner signoff |
| ISM Wave Observation | ARMED | Aug-29T21:00Z |