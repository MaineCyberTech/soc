# Phase 42 Field-Guardrail Check — Current Reading + Threshold Logic Review

**Report ID:** phase42-12-field-guardrail-check
**Phase:** 42
**Title:** Guardrail Reading CRIT 1852 (Raw) with Threshold Logic Review — Soft 1400/Hard 1800 Calibrated for a CLEAN Index; Addendum: During Legacy Window Raw-2000-Cap Proximity Is Informational-Only, Rejection Counter Is the True Signal (=0 Post-Birth Expectation)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-12-field-guardrail-check.md`

---

## 1. Current reading (fresh, verbatim)

```
$ bash ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.26   # 07:56:37Z rc=2
p40-field-growth index=wazuh-archives-4.x-2026.08.26 leaf_fields=1852 limit=2000 verdict=CRIT growth_per_day=0.0
branches: data:1747 syscheck:36 rule:27 GeoLocation:8 agent:6 decoder:6
```

Earlier ladder today: 1604 WARN → 1706 WARN → 1766 WARN → **1852 CRIT** (07:37, printed
growth 1175.5/day). Basis context: 1852 raw ≈ 937 unique-basis (report 10).

## 2. Threshold logic review

| Element | Value | Review finding |
|---|---|---|
| soft WARN | 1400 | Calibrated against the **unique-basis projection of a clean index**; on the legacy index it fires permanently due to 441-basis stats baggage → noise, not signal |
| hard CRIT | 1800 | Same calibration; legacy index crossed it this morning for baggage reasons while organic growth was +29 basis |
| effective limit | 2000 | Real ceiling; OS counts objects+multi too (~1978 counted vs 1852 raw print) |
| trend math | delta/Δt from state TSV | Prints misleading spikes (1175.5/day across a 1h45m gap); acceptable as triage hint only |

Conclusion: thresholds are CORRECT for their design target (clean index) and mis-leading
on the legacy index during the residual window.

## 3. Recommendation addendum (evidence-backed by this morning)

**During the legacy-index window (until 2026-08-27T00:00Z):**

1. Treat raw-2000-cap proximity (1852/2000 = 93%) as **informational-only**.
2. Treat the **rejection counter as the true operational signal**: it fired exactly when
   headroom actually exhausted (2746 rejections, bursts 07:02/07:45 — report 08), which
   the leaf counter alone did not predict precisely.
3. No-action-unless policy stands: no emergency limit-raise without owner approval per
   safety rules; current rejection count since 07:45:42Z = **0** (re-verified 08:20Z).
4. From birth onward the guardrail regains full authority on the newborn: fresh baseline
   row at t+1h, bands enforced as designed.

## 4. Tooling note (carried to backlog)

Guardrail prints raw basis; addendum template (report 13) quotes both bases. Optional
future enhancement: emit `unique_basis=` alongside `leaf_fields=` in one script pass
(no behavior change; keeps trend file compatible).
