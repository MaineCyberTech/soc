# Phase 43: Required Data Condition Verification

**Report ID:** phase43-10-field-c5-required.md
**Phase:** 43
**Title:** Phase 43 Required Data Condition Verification — C5 Leaf Count ≤1400
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T12:15:00Z
**Classification:** INTERNAL
**Status:** PENDING
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-10-field-c5-required.md`

---

## 1. Purpose

Verify the 08.27 archive index has ≤1400 total mapped leaf fields (C5 condition: leaf count ≤1400).

---

## 1. Verification Command

```bash
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.27
```

---

## 2. Expected Output

```
p40-field-growth index=wazuh-archives-4.x-2026.08.27 leaf_fields=1300 limit=2000 verdict=PASS growth_per_day=0.0
```

---

## 2. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C5 | `leaf_fields` ≤ 1400 (soft guardrail 1400, hard 1800, limit 2000) |

---

## 3. Projection

| Component | Expected Leaves (08.27) | 08.26 Actual |
|-----------|------------------------|--------------|
| data.stats (legacy) | **0** (removed) | 441 |
| data.win | ~80-90 | 92 |
| data.ubiquiti | ~35 | 36 |
| data.parameters | ~30 | 35 |
| data.audit | ~25 | 30 |
| data.service | ~25 | 30 |
| data.osquery | ~25 | 29 |
| data.process | ~25 | 28 |
| data.netinfo | ~20 | 22 |
| data.syscheck | ~15 | 20 |
| data.unifi | ~15 | 19 |
| data.rule | ~10 | 15 |
| data.os | ~10 | 14 |
| data.virustotal | ~10 | 13 |
| data.port | ~8 | 11 |
| **TOTAL** | **~1,250–1,350** | **1,852** |

---

## 4. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C5 | `leaf_fields` ≤ 1400 (projected: ~1,250–1,350) |

---

## 5. Status

**STATUS: PENDING** — Awaiting 08.27 index creation and first growth check (~00:05Z tonight).