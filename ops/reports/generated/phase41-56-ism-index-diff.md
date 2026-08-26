# Phase 41 ISM Index Diff — Methodology Pre-Staged

**Report ID:** phase41-56-ism-index-diff
**Phase:** 41
**Title:** DIFF-41-01 — Post-Wave Index Diff Methodology Defined And Fully Pre-Staged: Before-Artifact Exists (p41-ism-baseline.json), After-Capture/Diff/Attribution Procedure Written, Expected Deltas Enumerated (Exactly One Index Per Day, Zero Size Changes Elsewhere), Execution Deferred To Window
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:25:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-56-ism-index-diff.md`

---

## 1. Why staged now

The diff is only meaningful if the "before" side is frozen before the window opens.
It is (phase41-55). The "after" side must be captured identically once the wave is
observed, so the procedure is fixed in advance to prevent post-hoc method drift.

## 2. Procedure (executes inside the observation window)

1. **After-capture** — identical generator as the baseline:
   `_cat/indices/wazuh-*?format=json` + per-index `_plugins/_ism/explain` merge,
   saved as `ops/evidence/p41-ism-after-<capture-ts>.json` (new file, never overwrite).
2. **Set diff** — indices present in baseline but absent after ⇒ deletion set.
   Expected: exactly `{wazuh-archives-4.x-2026.08.15}` on Aug-29/30, then one per day.
3. **Size diff** — surviving indices' `store.size` may drift only by normal ingest;
   any *shrink* of a non-deleted archive index would be anomalous and escalated.
4. **Attribution** — every deletion must be explained by policy mechanics:
   explain output showing state `delete` executed, or index absent because policy
   completed. Anything not attributable to the `wazuh-archives-14d` policy is a
   finding, not noise.
5. **Report-out** — deltas table into the wave-observation follow-up report with raw
   outputs embedded; catalog updated.

## 3. Expected-delta envelope

| Signal | Expected | Anomalous if |
|--------|----------|--------------|
| Deleted index/day | 1 | ≥2 same-day, or zero past ETA+24h without explanation |
| Deleted set order | oldest-first sequential | out-of-order deletions |
| Non-archive indices | untouched | any change |
| Cluster health | green throughout | yellow/red coincident with action |

## 4. Non-goals

No execution now; no synthetic acceleration of ISM; no manual deletion to "make the
diff interesting". The diff proves the policy works — it only proves that if nobody
touches anything.
