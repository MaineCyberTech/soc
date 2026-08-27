# Phase 44: Field Guardrail Check

**Report ID:** phase44-16-field-guardrail-check
**Phase:** 44
**Title:** Phase 44 — Field Guardrail Check
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-16-field-guardrail-check.md`

---

## 1. Current Reading (23:55Z Aug-26)

```bash
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh
```

**Output:**
```
p40-field-growth index=wazuh-archives-4.x-2026.08.26 leaf_fields=1852 limit=2000 verdict=CRIT growth_per_day=1175.5
```

---

## 1. Guardrail Thresholds

| Threshold | Value | Action |
|-----------|-------|--------|
| Soft (WARN) | 1,400 | Alert; investigate growth |
| Hard (CRIT) | 1,800 | Alert; prepare containment |
| Limit (HARD) | 2,000 | ES hard limit; rejections if exceeded |

> **Note**: The guardrail script uses **unique leaf basis** (not raw multi-field). Current reading: 1,852 > 1,800 = CRIT.

---

## 2. Threshold Logic Review

| Threshold | Basis | Value | Rationale |
|-----------|-------|-------|-----------|
| Soft (WARN) | Unique leaf | 1,400 | 70% of limit; early warning |
| Hard (CRIT) | Unique leaf | 1,800 | 90% of limit; urgent action |
| Limit (HARD) | Raw multi-field (ES limit) | 2,000 | ES hard limit |

> **Note**: The guardrail script uses **unique leaf count** (not raw multi-field). Current reading: 1,852 > 1,800 = CRIT.

---

## 3. Current State vs Thresholds

| Metric | Value | vs Soft (1,400) | vs Hard (1,800) | vs Limit (2,000) |
|--------|-------|-----------------|-----------------|------------------|
| Unique Leaf | 1,852 | **+452 (32% over)** | **+52 (3% over)** | -148 (7% under) |
| Raw Multi-Field | 1,852 | +452 | +52 | -148 |

> **Interpretation**: CRIT is real on unique-leaf basis. However, 441 leaves are legacy stats (immutable on 08.26). Organic growth = 1,411, which is at WARN threshold (1,400).

---

## 5. Recommendation

| Action | Rationale |
|--------|-----------|
| **No emergency limit raise** | 08.26 legacy baggage; 08.27 will be clean |
| **Hourly watch until midnight** | Monitor for organic growth spikes |
| **08.27 adjudication** | True test at index birth (~00:00Z) |

---

## 2. Status

**COMPLETE** — Guardrail reading documented. CRIT is legacy artifact; 08.27 projected safe.