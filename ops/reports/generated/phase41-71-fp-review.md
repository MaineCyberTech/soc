# Phase 41 FP Review Verdict

**Report ID:** phase41-71-fp-review
**Phase:** 41
**Title:** FP-REVIEW-41-01 — False-Positive Review Verdict: All Canary-Marked Events Excluded From FP Math By Design, Four Natural Candidates Assessed UNKNOWN-Benign-Leaning, ZERO False Positives Observed In The Natural Population, Tuning Proposals NONE Warranted At This Population (Honest No-Op), Revisit Triggers Set
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:42:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-71-fp-review.md`

---

## 1. Scope

Review of the 12-alert rolling-7d sample (`ops/evidence/p41-fp-sampling/sample-25.json`,
extraction record phase41-70) under the labeling framework of phase41-69 §3.

## 2. Verdict table — VERIFIED against artifact

| Class | Count | FP-math treatment | Outcome |
|---|---|---|---|
| Canary-marked synthetic (sid 2027967, MCT-CANARY markers) | 8 | **Excluded by design** — true positives by construction (sanctioned canary injections) | Confirms detection+indexing lane works; carries no FP information |
| Natural candidates (sids 2260001, 2210038, 2100366 ×2) | 4 | Reviewed qualitatively | **UNKNOWN-benign-leaning** each; zero confirmed false positives |

Count-reconciliation honesty note: the marker-based separation yields 8/4
(marked/unmarked) rather than the ~11/1 anticipated at planning. The verdict
below is identical under either split, so the planning estimate error has no
operational consequence; artifact numbers are authoritative.

## 3. Findings

1. **ZERO false positives observed in the natural population.** No natural
   alert met the `false` definition (definitive non-target activity imposing
   recurring triage cost). All four candidates are generic protocol-level
   signatures firing on quiet-segment behavior consistent with benign causes:
   - sid 2260001 Applayer Wrong direction first Data — lone inbound
     protocol-ordering anomaly; parked pending recurrence.
   - sid 2210038 STREAM FIN out of window — TCP teardown edge case.
   - sid 2100366 GPL ICMP PING *NIX — two events, one host pair, classic
     monitoring-ping pattern.
2. **Tuning proposals: NONE warranted at this population.** With n=4 natural
   candidates and zero confirmed FPs, any threshold or rule modification would
   be evidence-free. This is an intentional, documented **no-op**: the correct
   engineering action at this signal volume is to change nothing and keep the
   baseline clean for the next cycle (phase41-73).
3. Canary lane validated as a side effect: P35-era and P40-E2E marked events
   traversed sensor → Wazuh → index correctly.

## 4. Revisit triggers (any one fires a new review cycle)

- ≥50 natural alerts accumulated in the universe, OR
- Any repeat offender: same SID ≥3 occurrences in natural traffic within
  rolling 7 days, OR
- Scheduled next-cycle review at Phase 42 open.

Until then: qualitative-only mode per phase41-69 §6; no statistical tuning
claims are made or permitted downstream.
