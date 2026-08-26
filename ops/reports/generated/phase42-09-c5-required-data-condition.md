# Phase 42 Condition C5 — Required-Data Leaf Band — PENDING-BIRTH (projection PASS)

**Report ID:** phase42-09-c5-required-data-condition
**Phase:** 42
**Title:** C5 Adjudication Package — Newborn Leaf Count ≤1400 Unique-Basis; Projection ~937 Basis / ~1100 Raw Day-One, Verdict-Insensitive Either Way
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** PENDING-BIRTH
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-09-c5-required-data-condition.md`

---

## 1. Condition

Newborn mapped-field count must sit at or below soft band 1400 by the adjudication read,
with hard fail only at ≥1800 (guardrail thresholds; effective ceiling 2000).

## 2. Exact check (from adjudicator)

```bash
bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.27 | head -1
```

Pass bands: `leaf_fields ≤1400` → PASS · `1401–1799` → PARTIAL band (growth attribution
required) · `≥1800` → FAIL. The script prints the raw basis; the unique-basis conversion
for the addendum uses the report 10 method.

## 3. Current interim status — projection inputs measured today

On legacy 08.26 (fresh runs embedded in reports 10/11): raw total **1852**, of which
legacy baggage `data.stats` = 877 raw / 441 basis. The newborn will NOT inherit that
baggage (mapping is per-index; emitters removed). Projected day-one composition:

| Component | Raw (proj.) | Basis (proj.) |
|---|---|---|
| Organic data.* (win 92b + VT +13 + osquery +1 + ubiquiti/audit/service/etc.) | ~700–800 | ~400–450 |
| Non-data branches (syscheck/rule/agent/GeoLocation/decoder/predecoder/cluster) | ~105 | ~105 |
| **Total projected** | **~800–900** | **~500–560** |

Even a pessimistic ×2 surge stays <1400 on either basis → verdict-insensitive
(reconciliation argument formalized in report 10 §3).

## 4. Post-birth action

Adjudicator C5 line verbatim to report 13; plateau sampling per report 14 catches any
post-birth drift (e.g., a producer reintroducing deep structures) before it can re-walk
the counter toward 2000.
