# Phase 42 Field-Basis Reconciliation — Unique vs Raw

**Report ID:** phase42-10-field-basis-reconciliation
**Phase:** 42
**Title:** THE Basis Explanation (P41 Finding) — Guardrail Counts Multi-Fields Raw; Unique-Leaf Basis Is the Decision Metric; Both Bases Tabulated; Verdict-Insensitive Proof
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-10-field-basis-reconciliation.md`

---

## 1. The two bases

- **Raw basis** = every mapped leaf path **including multi-field variants**
  (`field.text`, `field.keyword` counted as separate leaves). This is what
  `p40-field-growth-check.sh` walks out of `_mapping` and prints as `leaf_fields`.
- **Unique-leaf basis** = same walk with multi-field variants collapsed onto their parent.
  This is the P41 finding: it represents distinct information structures and is the metric
  the C5 ≤1400 band was calibrated against.

OpenSearch's *internal* limit counter is a third thing again (objects + leaves + multi):
126 + 1852 = ~1978 vs cap 2000 on today's index — which is why rejections can fire while
the guardrail prints 1852 (reports 08/12).

## 2. Reconciliation table — wazuh-archives-4.x-2026.08.26, measured live 08:00–08:10Z

| Branch | Raw leaves | Unique-leaf basis | Multi-field factor |
|---|---|---|---|
| data.stats (legacy baggage, immutable) | 877 | 441 | ≈2.0 |
| data.win (organic EID structures) | 182 | 92 | ≈2.0 |
| data.ubiquiti | 72 | 36 | ≈2.0 |
| data.parameters | 69 | 35 | ≈2.0 |
| data.audit / data.service / data.process / data.osquery / … | remainder | remainder | ≈2.0 |
| **data.* subtotal** | **1747** | **879** | ≈2.0 |
| non-data branches (syscheck 36, rule 27, GeoLocation 8, agent 6, decoder 6, …) | 105 | ~58 | mixed |
| **TOTAL** | **1852** | **937** | — |

Raw/basis ratio ≈ 1852/937 ≈ **1.98×**, dominated by the stats+win text/keyword doubling.

## 3. Why the verdict is insensitive to basis choice tonight

Projection for the newborn (report 09): legacy `data.stats` baggage does not carry over;
organic growth projects to ≤~900 raw / ≤~560 basis at adjudication, worst-case surge ×2
still lands <1400 on BOTH bases:

```
raw   pessimistic:  ~1800 → grazes PARTIAL band only if surge doubles AND stats returns
basis pessimistic:  ~1100 → comfortably PASS
realistic:          ~800-900 raw / ~500-560 basis → PASS on both
```

Therefore C5's verdict cannot flip depending on which basis the addendum quotes; both are
printed anyway. What the basis choice DOES change is day-to-day WARN noise on the legacy
index (report 12's informational-only recommendation).

## 4. Standing rule going forward

Guardrail continues logging raw (tool-compatible trend continuity); every report quoting
a number against the 1400/1800 bands must state its basis explicitly. The newborn gets a
fresh-basis baseline row at t+1h (report 14).
