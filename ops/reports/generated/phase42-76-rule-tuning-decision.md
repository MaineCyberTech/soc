# Phase 42 Rule Tuning Decision — TUNE-DEC-42-01

**Report ID:** phase42-76-rule-tuning-decision
**Phase:** 42
**Title:** Rule Tuning Decision: NO-TUNING — Evidence-Backed (Zero Natural FP Signal At n=2, Zero Repeat Offenders, Zero New SIDs); rules_failed=15 Remains A Separate Backlogged Hygiene Item With suricata -T Verbose Capture As Its Identification Path When Scheduled
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:35:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-76-rule-tuning-decision.md`

---

## 1. Decision

**NO-TUNING.** No threshold, filter, suppression, or rule modification is
applied to the Suricata ruleset in this cycle.

## 2. Evidence basis

| Input | Value (live, phase42-74) | Supports NO-TUNING? |
|---|---|---|
| Natural population | 2 alerts / rolling 7d (sids 2260001 ×1, 2210038 ×1) | Yes — far below any evidence-bearing volume |
| Confirmed false positives | **0** across both cycles (P41 n=4, P42 n=2) | Yes — nothing to tune against |
| Repeat offenders | None (max natural SID count 1/7d) | Yes |
| New natural SIDs | None | Yes |
| Canary lane | 8/8 marked events flowing end-to-end | Yes — detection lane healthy; tuning would add risk without a target |

Precedent: phase41-71 §2 established the identical no-op at n=4. Modifying any
rule today would be evidence-free by the same standard.

## 3. rules_failed=15 — explicitly NOT a tuning action

The sensor's `detect_engines.rules_failed=15` counter (rules_loaded=529,
rules_skipped=0) remains logged as a **separate hygiene item** per
phase41-72 §4 and stays on the remediation backlog:

- Identification path when scheduled: `suricata -T` verbose config-test capture
  on the sensor to enumerate exactly which 15 rule files/entries fail load and
  why.
- Disposition discipline: it is an engine-hygiene/backlog item, not an FP
  response; conflating it with tuning is prohibited so the FP baseline stays
  clean.
- No cycle date committed here; it advances when backlog scheduling reaches it.

## 4. Triggers re-armed

Unchanged from phase41-71 §4: ≥50 natural alerts OR any repeat offender
(same SID ≥3 / rolling 7d) fires an immediate review; otherwise next weekly
slot governs. The proposals register (`phase41-72`) remains EMPTY-BY-EVIDENCE.
