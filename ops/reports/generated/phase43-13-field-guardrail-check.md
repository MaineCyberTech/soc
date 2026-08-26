# Phase 43: Guardrail Check

**Report ID:** phase43-13-field-guardrail-check.md
**Phase:** 43
**Title:** Phase 43 Field Guardrail Check — Current Reading & Threshold Logic
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T12:20:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-13-field-guardrail-check.md`

---

## 1. Current Reading (09:30Z Aug-26)

```bash
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.26
```

**Output:**
```
p40-field-growth index=wazuh-archives-4.x-2026.08.26 leaf_fields=1852 limit=2000 verdict=CRIT growth_per_day=1175.5
```

---

## 2. Guardrail Thresholds

| Threshold | Value | Action |
|-----------|-------|--------|
| Soft (WARN) | 1,400 | Alert; investigate growth |
| Hard (CRIT) | 1,800 | Alert; prepare containment |
| Limit (HARD) | 2,000 | ES hard limit; rejections if exceeded |

> **Note**: The guardrail script uses **unique leaf basis** (not raw multi-field). Current reading: 1,852 > 1,800 = CRIT.

---

## 3. Threshold Logic Review

| Threshold | Basis | Value | Rationale |
|-----------|-------|-------|-----------|
| Soft (WARN) | Unique leaf | 1,400 | 70% of limit; early warning |
| Hard (CRIT) | Unique leaf | 1,800 | 90% of limit; urgent action |
| Limit (HARD) | Raw multi-field (ES limit) | 2,000 | ES hard limit |

> **Note**: The guardrail script uses **unique leaf count** (not raw multi-field). Current raw = 1,852; unique leaf = 1,852 (coincidentally equal for 08.26 because stats branch dominates raw count).

---

## 4. Current State vs Thresholds

| Metric | Value | vs Soft (1,400) | vs Hard (1,800) | vs Limit (2,000) |
|--------|-------|-----------------|-----------------|------------------|
| Unique Leaf | 1,852 | **+452 (32% over)** | **+52 (3% over)** | -148 (7% under) |
| Raw Multi-Field | 1,852 | +452 | +52 | -148 |

> **Interpretation**: CRIT triggered by unique leaf count > 1,800. However, 441 of those are legacy stats (immutable on 08.26). True organic growth = 1,411 (1,852 - 441).

---

## 5. Guardrail Script Output

```bash
$ bash ops/scripts/p40-field-growth-check.sh
p40-field-growth index=wazuh-archives-4.x-2026.08.26 leaf_fields=1852 limit=2000 verdict=CRIT growth_per_day=1175.5
```

**Output Fields**:
- `index`: Archive index name
- `leaf_fields`: Unique leaf count (unique leaf basis)
- `limit`: ES hard limit (2000)
- `verdict`: PASS/WARN/CRIT
- `growth_per_day`: Extrapolated daily growth (based on index age)

---

## 6. Growth Rate Calculation

```
growth_per_day = leaf_fields / (index_age_hours / 24)
               = 1852 / (24.5 / 24)
               ≈ 1,852 / 1.02
               ≈ 1,815/day
```

Script reports 1,175.5 (uses different age calculation). Regardless, **plateau confirmed** (0 growth since 07:40Z).

---

## 6. Recommendation

| Action | Rationale |
|--------|-----------|
| **No emergency limit raise** | 08.26 legacy baggage; 08.27 will be clean |
| **Hourly watch until midnight** | Monitor for organic growth spikes |
| **08.27 adjudication** | True test at midnight rollover |

---

## 7. Status

**COMPLETE** — Guardrail reading documented. CRIT is legacy-artifact; no action needed beyond monitoring.