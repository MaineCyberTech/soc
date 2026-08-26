# Phase 41 Rule Tuning Proposals Register

**Report ID:** phase41-72-rule-tuning-proposals
**Phase:** 41
**Title:** TUNE-REG-41-01 — Rule Tuning Proposals Register EMPTY-BY-EVIDENCE (No FP Signal Exists To Justify Any Proposal; Rationale Documented); Standing Proposal Process Defined For Future Cycles Via Review-Cadence Threshold Gate; rules_failed=15 Logged As Separate Hygiene Item With Quick-Attempt Outcome And Backlog Entry
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:44:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-72-rule-tuning-proposals.md`

---

## 1. Register status: EMPTY-BY-EVIDENCE

| Proposal ID | Rule/SID | Change | Evidence basis |
|---|---|---|---|
| *(none)* | — | — | — |

**Why empty (documented so absence cannot be misread as oversight):**

1. Zero false positives were observed in the natural population
   (phase41-71 §3.1). A tuning proposal requires an FP or triage-cost signal;
   none exists in this cycle's data.
2. Population is below the statistical stop-condition (phase41-69 §6):
   12 total alerts / 7 days, 4 of them natural. Any precision statistic would
   be noise dressed as analysis.
3. All four natural candidates are UNKNOWN-benign-leaning singletons or
   low-rate pairs with no operator cost incurred — no actionability flag set.

The honest engineering action is **no tuning applied** (regression-test
consequence recorded in phase41-73).

## 2. Standing proposal process (defined now, for future cycles)

1. Trigger: revisit conditions of phase41-71 §4 fire (≥50 natural alerts,
   repeat-offender SID, or scheduled Phase-42+ review).
2. A proposal enters this register ONLY with: SID + signature, labeled sample
   events (artifact path + sha256), proposed change class (threshold / sids
   exclusion / flowbits / suppression scope), expected FP reduction, and a
   rollback statement.
3. Approval gate: rule changes touch production detection posture → operator
   sign-off recorded in the change register before application (AGENTS.md
   Approval-Gated Operations).
4. Cadence: register reviewed at each phase closeout alongside the FP baseline
   report series.

## 3. Baseline hygiene context

ET Open curated ruleset: **529 rules loaded**, reported via suricatasc
`detect.engines` on the sensor. Detection lane demonstrably functional
(canary alerts flowing end-to-end).

## 4. rules_failed=15 — separate hygiene item (NOT a tuning proposal)

Sensor reports **15 rules failed to load**. Identification attempt made this
cycle:

- Quick-attempt outcome: `suricata` / `suricatasc` binaries are not present on
  this orchestration box and no Suricata container runs locally (the sensor is
  a separate SPAN-segment host), so a verbose `suricata -T` config-test capture
  is not executable from here without sensor-side access.
- Disposition: **BACKLOGGED** as sensor-side hygiene — capture
  `suricata -T -v` output (or engine-error logs) on the sensor during the next
  maintenance window, enumerate the 15 failing rules, and classify each as
  syntax / dependency / version-skew. Impact today is bounded: loaded-set is
  stable at 529 and all canary detections fire, so this is hygiene, not an
  exposure. Tracked for Phase 42 sensor access window.
