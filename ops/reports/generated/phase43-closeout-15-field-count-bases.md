# Phase 43 Closeout: Field Count Bases Report

**Report ID:** phase43-closeout-15-field-count-bases
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Field Count Basis Reconciliation
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T21:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-15-field-count-bases.md`

---

## 1. Two Counting Methodologies

### A. Raw Multi-Field Count (Guardrail Metric)
- **Definition**: Every field occurrence in index mapping, including nested fields counted multiple times per document path
- **Source**: Elasticsearch mapping recursive traversal
- **08.26 Value**: **1,852** (CRIT at 1852/2000)
- **What it captures**: Every nested object property counted separately

### B. Unique Leaf-Field Basis (Capacity Metric)
- **Definition**: Unique top-level field names under `data.*` (first-level branching)
- **Source**: Recursive leaf count of `data.*` properties
- **08.26 Value**: **1,766 → 1,852** (growth from 1,766 to 1,852 in ~3 hours)
- **What it captures**: Unique leaf paths in mapping

---

## 2. Reconciliation Table

| Metric | Raw Multi-Field | Unique Leaf | Difference |
|--------|----------------|-------------|------------|
| `data.stats` | 877 | 441 | +436 (nested expansion) |
| `data.win` | ~180 | 92 | +88 |
| `data.ubiquiti` | ~70 | 36 | +34 |
| `data.parameters` | ~70 | 35 | +35 |
| `data.audit` | ~60 | 30 | +30 |
| `data.service` | ~60 | 30 | +30 |
| `data.osquery` | ~55 | 29 | +26 |
| `data.process` | ~55 | 28 | +27 |
| `data.netinfo` | ~22 | 22 | 0 |
| `data.syscheck` | ~20 | 20 | 0 |
| `data.unifi` | ~19 | 19 | 0 |
| `data.rule` | ~15 | 15 | 0 |
| `data.os` | ~14 | 14 | 0 |
| `data.virustotal` | ~13 | 13 | 0 |
| `data.port` | ~11 | 11 | 0 |
| **TOTAL** | **~1,852** | **~1,766** | **+86** |

---

## 3. Key Insight

| Basis | Used For | Threshold |
|-------|----------|-----------|
| **Raw Multi-Field** | ES hard limit (`index.mapping.total_fields.limit`) | 2,000 (hard) |
| **Unique Leaf** | Growth projection / capacity planning | 1,400 (soft) / 1,800 (hard) / 2,000 (limit) |

---

## 4. 08.27 Projection (Post-Containment)

| Basis | Projected Value | vs Limit |
|-------|----------------|----------|
| Raw Multi-Field | ~1,300–1,400 | Well under 2,000 |
| Unique Leaf | ~1,250–1,350 | Well under 1,400 soft |

> **Conclusion**: The 08.26 CRIT is legacy baggage. 08.27 will be well within limits on both bases.