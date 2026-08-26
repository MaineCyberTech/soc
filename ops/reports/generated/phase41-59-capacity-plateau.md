# Phase 41 Capacity Plateau — STABLE Classification

**Report ID:** phase41-59-capacity-plateau
**Phase:** 41
**Title:** CAP-41-01 — Capacity Classification With Repeated Measurements Across Phases: 82% (P39 Read) → 82% (P40 Read) → 84%/83% (Two P41 Reads Today) — Plateau Verdict STABLE Within A 2-Point Band, Watermark Distance Math Shown (≈7.8G To Low-85%), No Breach Trajectory Before Wave
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:28:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (plateau verdict: STABLE)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-59-capacity-plateau.md`

---

## 1. Measurement series (repeated, cross-phase)

| Read | When | Used % | Source |
|------|------|--------|--------|
| M1 | P39 phase read | 82% | prior-phase report corpus |
| M2 | P40 phase read | 82% | prior-phase report corpus |
| M3 | 2026-08-26T05:14Z | 84% | this run `df -h /` (118G/148G, 24G avail) |
| M4 | 2026-08-26T05:19Z | 83% | this run `df -h /` (118G/148G, 25G avail) |

Four reads over three phases span **82–84%**: a two-point band around a flat mean.
Day-over-day movement is sub-percent once normal ingest churn is accounted.

## 2. Verdict

**Plateau classification: STABLE.** Not declining, not accelerating; the
compact-stats effect (phase41-58) has flattened marginal growth while awaiting the
wave that will produce the first genuine step-down.

## 3. Watermark distance math

OpenSearch low watermark in force: **85%**.

```
threshold_used  = 0.85 × 148G            = 125.8G
current_used    = 118G                   (both reads today)
distance        = 125.8 − 118            ≈ 7.8G  (≈5.3% of disk)
post-containment burn                ≈ 0.38G/day replicated archives
runway at burn rate                  ≈ 20 days  …
but wave lands in 3.7 days deleting  ≈ 14G     ⇒ runway moot before breach
```

High (90%) and flood (95%) stages sit another ~7.4G and ~14.8G further out
respectively; neither is reachable before the wave under any measured trajectory.

## 4. Caveats

Percentages move ±1 point with transient container-layer churn (two same-hour reads
differed); plateau claims rest on the multi-phase series, not single reads. Next
scheduled re-read: at the wave checkpoint (Aug-29 21:00Z) and daily post-wave to
confirm the promised step-down actually materializes.
