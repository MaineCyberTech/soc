# Phase 41 FP Sampling Plan — MINIMAL-POPULATION Adaptation

**Report ID:** phase41-69-fp-sampling-plan
**Phase:** 41
**Title:** FP-SAMPL-41-01 — False-Positive Sampling Plan Adapted To Observed Minimal-Population Reality: Rolling-7d Universe Of 12 Suricata Alerts, Canary-Marker Labeling Framework (true-positive / benign / false / unknown / actionability), MCT SOC Reviewer Assignment, Metadata-Only Privacy Note, Explicit Stop-Condition (Population <30/Month → Qualitative-Only Review, No Statistical Tuning Claims)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:38:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-69-fp-sampling-plan.md`

---

## 1. Purpose

Establish the Phase-41 false-positive sampling and review plan for the Suricata
detection lane, adapted honestly to the observed alert volume rather than to a
textbook assumption of statistical abundance.

## 2. Sample design — VERIFIED against live data

| Parameter | Value |
|---|---|
| Sample period | Rolling 7 days (2026-08-19 → 2026-08-26) |
| Alert universe | **12 alerts total** (`ops/evidence/p41-fp-sampling/sample-25.json`, `hits.total.value=12`) |
| Source index family | `wazuh-alerts-4.x-*` (Suricata-rule alerts via Wazuh) |
| Ruleset in force | ET Open curated, **529 rules loaded**, 15 failed-to-load (sensor-reported via suricatasc `detect.engines`; separate hygiene item, phase41-72 §4) |
| Extraction artifact | `ops/evidence/p41-fp-sampling/sample-25.json` |

## 3. Labeling framework

Every sampled alert receives exactly one primary label plus an actionability flag:

| Label | Definition |
|---|---|
| `true-positive` | Detects activity that is actually malicious or was intentionally injected for test/validation |
| `benign` | Detects real but harmless activity; correct behavior of a generic signature, not a tuning target by itself |
| `false` | Alerts on activity that is definitively NOT what the rule intends to catch AND recurs enough to impose triage cost |
| `unknown` | Insufficient evidence at population n=1 or context absent; parked pending recurrence |
| `actionability` | Secondary flag (yes/no): does this alert deserve operator time if it recurred daily? |

Separation method: alerts carrying `MCT-CANARY` markers in
`rule.description` are synthetic test events and are **excluded from FP math
by design** (they are true positives by construction — canary injection).

## 4. Reviewer assignment

Reviewer: **MCT SOC** (overall owner per AGENTS.md Escalation & Owners).
Agent role: extraction, labeling proposal, evidence packaging only. No agent
modifies rulesets on the basis of this review (approval-gated).

## 5. Privacy note

The sample artifact contains **alert metadata only** (timestamps, signature
IDs, signature descriptions, source/destination IPs, one HTTP hostname field).
No payload capture exists in the sample beyond these metadata fields. The
artifact is stored under `ops/evidence/` (treated as immutable per AGENTS.md)
with INTERNAL classification.

## 6. Stop-condition (statistical honesty clause)

**If the natural (non-canary) alert population remains below ~30 alerts/month,
this program runs in qualitative-only mode:** single-event qualitative review,
no precision/recall statistics, no rate-based tuning claims, and no rule
threshold changes justified on statistical grounds.

Current observed universe (12 total over 7 days, of which 8 are canary-marked)
is **far below** that threshold. Baseline FRAMEWORK is therefore established
this phase; any future claim of "FP rate" is explicitly out of scope until the
population trigger fires.

Revisit trigger: ≥50 natural alerts accumulated, OR any repeat-offender
signature emerging (≥3 occurrences of the same SID in natural traffic within
a rolling 7 days), OR scheduled next-cycle review at Phase 42.

## 7. Downstream records

- Extraction record: phase41-70-fp-sample-extract.md
- Review verdict: phase41-71-fp-review.md
- Tuning proposals register: phase41-72-rule-tuning-proposals.md
- Tuning regression test: phase41-73-rule-tuning-test.md
- Baseline report: phase41-74-fp-baseline-report.md
