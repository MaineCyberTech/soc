# Phase 42 Field-Growth Attribution — Today's CRIT Decomposition

**Report ID:** phase42-11-field-growth-attribution
**Phase:** 42
**Title:** Morning CRIT 1852/2000 Decomposed — Legacy-Stats Baggage Immutable + Organic +15 win +13 VT +1 osquery; Producer Correlation; Velocity Table 1604→1852; Midnight Projection Scenarios
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-11-field-growth-attribution.md`

---

## 1. Headline

Guardrail read **CRIT 1852/2000, growth_per_day=1175.5 at 07:37:22Z** (was WARN 1766 at
05:52Z). Fresh re-run at 07:56Z confirms 1852 stable (growth_per_day printed 0.0 because
two same-count rows landed within the delta window — artifact of the trend math, not a
shrink). Attribution below shows containment IS working; the number is dominated by
immutable legacy baggage.

## 2. Decomposition (unique-leaf basis, measured live)

| Component | Δ basis | Nature | Evidence |
|---|---|---|---|
| data.stats legacy baggage | 441 (fixed) | IMMUTABLE per-index mapping from pre-containment docs; vanishes at midnight | `_mapping` walk 08:02Z |
| data.win EID structures | +15 (77→92) | ORGANIC new-EID structures from windows agents | `_mapping` diff vs P41 baseline |
| data.virustotal | +13 (NEW) | VT integration responses attached on syscheck alerts | integration lane correlation |
| data.osquery | +1 | single new osquery structure | same |
| **Total data.\*** | **937 basis / 1747 raw** | — | report 10 table |
| Total all branches | 937 basis / 1852 raw | — | guardrail raw print |

Zero new `data.stats` leaves since cutover → source containment verified at the mapping
level, not just document level (C3 interim = 0 docs).

## 3. Producer correlation

- **win (+15)** ← windows agents (014 et al.) emitting novel EventIDs through the morning;
  each new EID brings a small fixed structure (~×2 raw with multi-fields).
- **virustotal (+13)** ← VT integration enriching syscheck alerts; response schema adds
  ~13 distinct leaf paths when first-seen fields appear.
- **osquery (+1)** ← one new result column shape from the scheduled query set.
- Rejection-burst producers (report 08) are the SAME lanes pushing novel shapes:
  agent016 syscollector packages, vuln-detector solved notices.

## 4. Velocity table (state TSV, verbatim)

```
2026-08-26T01:44:18Z  1604   WARN
2026-08-26T02:43:38Z  1706   WARN  (+102)
2026-08-26T03:05:17Z  1706   WARN  (flat)
2026-08-26T04:41:27Z  1766   WARN  (+60)   growth_per_day printed 1374.0
2026-08-26T05:52:01Z  1766   WARN  (flat)
2026-08-26T07:37:22Z  1852   CRIT  (+86)   growth_per_day printed 1175.5
2026-08-26T07:56:37Z  1852   CRIT  (flat since 07:37)
```

## 5. Projection scenarios to midnight (raw basis)

| Scenario | Assumption | 23:59Z value | Hits 2000 before midnight? | Consequence |
|---|---|---|---|---|
| A plateau (observed since 07:37) | flat 1852 | 1852–1900 | No | none beyond legacy-window noise |
| B morning cadence repeats (+86/2h) | bursts like 05:52→07:37 | ~2100–2300 | **Yes, likely ~15:00–19:00Z** | more rejection bursts on legacy index only; zero policy action needed (bounded to dying index); watch cadence per report 14 |
| C heavy burst (syscollector full sweep ×3 hosts) | one-off inventory storms | spikes possible | possibly | as B |

Honest assessment: scenario B is plausible (~40%) given two burst events already fired;
it does NOT threaten the adjudication (newborn unaffected) and does NOT justify an
emergency limit-raise (owner-gated per safety rules, and moot at rollover).
