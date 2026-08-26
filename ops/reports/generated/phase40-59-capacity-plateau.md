# Phase 40 Capacity Plateau Classification

**Report ID:** phase40-59-capacity-plateau
**Phase:** 40
**Title:** Plateau STABLE-DRIFTING-DOWN (84%→82% Across P39→P40 Repeated Measurements) — Drivers, Post-Wave RECOVERING Projection, Do-Not-Touch Watermark Statement
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:25:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-59-capacity-plateau.md`

---

## 1. Method

Repeated `df -h` + `_cat/allocation` measurements across phase reports;
classify trajectory rather than single readings. Same host FS (`/dev/sda1`,
148 G) throughout — comparable series.

## 2. Measurement series

| When | Source report | Reading |
|---|---|---|
| P39 (Aug-25 era) | phase39-74-disk-relief-proof | `/dev/sda1 148G 119G 24G 84% /` |
| P40 (today 02:18Z) | phase40-58 §1 | `/dev/sda1 148G 116G 26G 82% /` |

Δ = **−3 GB used, −2 percentage points over ~1 day.**

## 3. Driver attribution

1. **Alert-volume dip**: alerts 50.1–58.6 MB/day band with 08.23–08.25 at the
   low end (50.1/57.9/57.3), archive quiet days 98–140 MB on 08.23/08.24 —
   less inflow than the 08.15–08.19 spike era.
2. **Cleanup actions** (P39/P40): temp/evidence hygiene, restored-index
   removals, log pruning — small but non-zero one-time reclaims.
Neither driver is structural: both can reverse with a busy threat day.

## 4. Classification

**STABLE-DRIFTING-DOWN (currently).** Usage oscillates in an ~82–84% band
with slight negative drift. NOT yet RECOVERING: no deletion mechanism has
fired; the drift depends on workload mood, not on enforced retention.

Post-wave projection (from phase40-58 table): once deletions begin
Aug-29+ and the 14-day window reaches steady state, classification flips to
**RECOVERING (projected)** with expected descent toward high-70s % within a
week of the wave.

## 5. Do-not-touch-watermarks statement

Cluster/FS watermark thresholds are **DO-NOT-TOUCH**: they are correctly
positioned for this stack's failure modes and were ratified in earlier phases.
No operator may lower `low`/`high`/`flood_stage` watermarks, disable
`disk.watermark.enable`, or add block exceptions to "buy time" before the
wave. If 85% low-watermark proximity becomes acute before Aug-29, the correct
moves are (a) confirm snapshot health, (b) escalate — never threshold edits.

## 6. Verdict

STABLE-DRIFTING-DOWN at 82%; flip conditions recorded; watermarks frozen by
policy. Next re-measure scheduled post-wave (Aug-30) inside phase40-60's
monitoring cycle.
