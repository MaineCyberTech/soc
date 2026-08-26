# Phase 43: FP Population Check

**Report ID:** phase43-74-fp-population-check.md
**Phase:** 43
**Title:** Phase 43 FP Population Check
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:45:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-74-fp-population-check.md`

---

## 1. Purpose

Rerun population check against trigger thresholds (≥50 natural alerts or repeat offender).

---

## 1. Live Query (Rolling 7d)

```bash
curl -sk -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-alerts-*/_count?q=rule.groups:suricata"
```

**Result**: `{"count":10}`

---

## 2. Population Breakdown

| Category | Count | SIDs |
|----------|-------|------|
| **Total** | 10 | — |
| Canary (synthetic) | 8 | 2027967 (×8) |
| Natural | 2 | 2260001 (×1), 2210038 (×1) |
| Aged Out | 2 | 2100366 (aged out of 7d window) |

---

## 2. Trigger Evaluation

| Trigger | Threshold | Current | Fired? |
|---------|-----------|---------|--------|
| Natural alerts ≥ 50 | 50 | 2 | **NO** |
| Repeat offender (same SID ≥ 3×) | 3 | Max 1 (sid 2260001 ×1) | **NO** |
| New natural SID | Any | 0 new | **NO** |

---

## 3. Verdict

**CONTINUE-QUALITATIVE** — Population remains minimal (10 total, 2 natural); triggers not met. Qualitative review only. Next check: weekly.

---

## 4. Status

**COMPLETE** — Population check complete; qualitative monitoring continues.