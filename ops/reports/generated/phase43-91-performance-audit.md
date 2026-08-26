# Phase 43: Performance Audit

**Report ID:** phase43-91-performance-audit.md
**Phase:** 43
**Title:** Phase 43 Performance & Efficiency Audit
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:25:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-91-performance-audit.md`

---

## 1. System Resources

| Metric | Value | Trend |
|--------|-------|-------|
| CPU (PSI avg10) | ~2.5% | Stable |
| Memory | 11.1/15.6 GiB (71%) | Stable |
| Swap | 5.0/8.0 GiB (63%) | Stable |
| Disk I/O | Moderate | Stable |
| Disk Usage | 85% (120G/148G) | Stable |

---

## 1. Rejection Rate (Field Errors)

| Period | Rate | Notes |
|--------|------|-------|
| Pre-containment (08.25) | ~150/min | 200k/day |
| 08.26 Cutover | 150/min → 0 | Midnight rollover |
| Post-cutoff (00:00-07:45) | 2,746 total | Bursts at 07:02, 07:45 |
| Post-07:45 | **0** | Flatline confirmed |

> **Savings**: ~200k rejections/day eliminated.

---

## 2. Alert Volumes (Today)

| Index | Docs (24h) | Size |
|-------|------------|------|
| wazuh-alerts-4.x-2026.08.26 | 53,347 | 45 MB |
| wazuh-archives-4.x-2026.08.26 | 207,119 | 503 MB |
| wazuh-states-* | ~50k | ~15 MB |

---

## 3. Shuffle Latency

| Path | Latency (p50) | Notes |
|------|---------------|-------|
| Hook → Execution Start | ~50ms | API call |
| Execution → IRIS | ~2.3s | E2E (P41 measured) |
| IRIS Response | ~200ms | HTTP 200 |

---

## 4. Avoidable Work Eliminated

| Source | Before | After | Savings |
|--------|--------|-------|---------|
| Shuffle Repair Churn | 92 restarts/day | 0 | 1,381 restarts saved |
| Field Rejections | 200k/day | 0 | Indexing CPU saved |
| Duplicate Executions | N/A | Dedup active | Counter working |

---

## 5. Status

**COMPLETE** — Performance audit complete; major gains documented.