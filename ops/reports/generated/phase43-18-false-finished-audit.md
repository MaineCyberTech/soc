# Phase 43: False FINISHED Audit

**Report ID:** phase43-18-false-finished-audit.md
**Phase:** 43
**Title:** Phase 43 False FINISHED Audit — FINISHED ≠ Delivered
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T13:10:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-18-false-finished-audit.md`

---

## 1. Purpose

Audit the discrepancy between Shuffle workflow `FINISHED` status and actual IRIS delivery (`HTTP 200` with success body).

---

## 1. The FINISHED ≠ Delivered Problem

| Status | Meaning |
|--------|---------|
| `FINISHED` | Shuffle workflow engine completed all nodes without exception |
| `DELIVERED` | Downstream system (IRIS) accepted payload with `HTTP 200` + success body |

> **Critical**: A workflow can be `FINISHED` but have `success: false` in node results (e.g., downstream HTTP 400/500, DNS failure, timeout).

---

## 2. Historical Evidence (P41/P42)

| Workflow | Total Executions | FINISHED | Delivered (HTTP 200) | Failed (FINISHED but failed) |
|----------|------------------|----------|----------------------|------------------------------|
| eb937a37 (Class-A) | 83 (24h) | 83 | **46** | 31 (FINISHED but HTTP error) |
| e133a645 (Packet) | 18 | 12 | **3** (all test) | 6 (ABORTED due to function errors) |

> **Key Finding**: 31/83 Class-A executions were `FINISHED` but **failed delivery** (IRIS DNS failures, HTTP 400). The monitor script correctly counts these as `failed`, not `delivered`.

---

## 3. Monitor Script Logic (p39-iris-delivery-check.sh)

```bash
# Simplified logic
for execution in executions:
    for result in execution.results:
        if result.success == true and result.status == 200:
            delivered++
        elif result.success == false:
            failed++
        else:
            other++
```

> **Key**: Only counts `success: true` + `status: 200` as `delivered`. `FINISHED` with `success: false` → `failed`.

---

## 4. False FINISHED Audit Results

| Workflow | FINISHED | Delivered | Failed (FINISHED+failed) | Aborted |
|----------|----------|-----------|--------------------------|---------|
| eb937a37 (24h) | 83 | 46 | 31 | 3 |
| e133a645 (packet) | 12 | 3 | 6 | 3 |

> **False FINISHED Rate**: Class-A = 37% (31/83), Packet = 50% (6/12)

---

## 5. Root Causes of False FINISHED

| Cause | Count | Example |
|-------|-------|---------|
| IRIS DNS failure | 28 | `NameResolutionError` in HTTP node |
| IRIS HTTP 400 | 3 | `alert_status_id` missing / malformed body |
| IRIS timeout | 2 | Connection timeout |
| Shuffle function error | 1 | `json_dumps` missing (platform defect) |

---

## 5. Monitoring Implications

| Metric | Naive (FINISHED) | Accurate (Delivered) |
|--------|------------------|----------------------|
| "Success Rate" | 100% (83/83) | 55% (46/83) |
| Alerting on "FINISHED" | **False sense of security** | — |

> **Conclusion**: Monitor **must** distinguish `FINISHED` + `success: true` + `status: 200` from `FINISHED` + `success: false`. Current monitor script does this correctly.

---

## 5. Status

**COMPLETE** — False FINISHED audit complete. Monitor logic validated. No false sense of security in current monitoring.