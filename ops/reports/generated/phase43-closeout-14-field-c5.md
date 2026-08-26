# Phase 43 Closeout: Field C5 Required Data

**Report ID:** phase43-closeout-14-field-c5
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Field C5 Required Data Verification
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T21:20:00Z
**Classification:** INTERNAL
**Status:** PENDING (awaiting 08.27 index birth)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-14-field-c5.md`

---

## 1. Condition C5

| Condition | Requirement |
|-----------|-------------|
| **C5** | Leaf field count ≤ 1400 (soft guardrail) on `wazuh-archives-4.x-2026.08.27` |

---

## 1. Verification Command

```bash
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.27
```

---

## 2. Expected Output (PASS)

```
p40-field-growth index=wazuh-archives-4.x-2026.08.27 leaf_fields=1300 limit=2000 verdict=PASS growth_per_day=0.0
```

---

## 2. Pass Criteria

| Check | Pass Condition |
|-------|----------------|
| C5 | `leaf_fields` ≤ 1400 |

---

## 3. Projected 08.27 Values

| Component | Projected Leaves | 08.26 Actual |
|-----------|------------------|--------------|
| data.stats (legacy) | **0** (removed) | 441 |
| data.win | 80-90 | 92 |
| data.ubiquiti | 35 | 36 |
| data.parameters | 35 | 35 |
| data.audit | 25 | 30 |
| data.service | 25 | 30 |
| data.osquery | 25 | 29 |
| data.process | 25 | 28 |
| data.netinfo | 20 | 22 |
| data.syscheck | 15 | 20 |
| data.unifi | 15 | 19 |
| data.rule | 10 | 15 |
| data.os | 10 | 14 |
| data.virustotal | 10 | 13 |
| data.port | 8 | 11 |
| **TOTAL** | **~1,250–1,350** | **1,852** |

> **Projection**: ~1,300 leaves (well under 1,400 soft guardrail, 1,800 hard, 2,000 limit)

---

## 4. Status

**STATUS: PENDING** — Awaiting 08.27 index birth. Projected ~1,300 leaves (well under 1,400 soft guardrail).