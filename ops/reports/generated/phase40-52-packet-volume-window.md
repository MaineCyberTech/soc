# Phase 40 Packet Volume-Window Measurement Plan — VOL-PKT-01

**Report ID:** phase40-52-packet-volume-window
**Phase:** 40
**Title:** Volume-Window Measurement Plan VOL-PKT-01 (BLOCKED) — 24 h Post-Certification Observation Design: Metrics, Latency Percentiles, Operator Workload, FP Sampling, Case-Quality Rubric, Acceptance Thresholds
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:41:30Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** VOL-PKT-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-52-packet-volume-window.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)
**Companion to:** ROUT-39-02 §4 FP-review process (carried forward)

---

## 1. Blocker

The window can only observe a CERTIFIED, ENABLED test lane running continuously —
import (IMP-40-01), all proof gates (REPLAY/MAL/DSF/DNF), and certification must
precede it. The measurement plan is fixed now to prevent post-hoc metric shopping.
**No simulated PASS; no projected numbers presented as observations.**

## 2. Window Definition

- Duration: **24 consecutive hours**, single uninterrupted span, starting at a
  register-recorded timestamp immediately after ROUT-PKT precondition sign-off.
- Lane state: packet workflow enabled, webhook bound ONLY if K1-class source wiring
  was separately approved; otherwise driven by controlled submissions + natural
  sensor traffic (agent 016 EVE path) reaching the isolated trigger.
- All instrumentation keys per phase40-44/-46 namespaces (`real_*`, day buckets).

## 3. Metric Set (collected hourly, reported daily)

| Metric | Source | Notes |
|---|---|---|
| executions_total | executions API count | includes malformed/suppressed/failures |
| routed_count | `done-routed-log` terminals / IRIS `[p40-test]` rows | cross-checked two ways |
| duplicates_suppressed | `duplicate-suppressed-logonly` terminals + dedup_hit bucket | |
| malformed_rejected | reject day-buckets | split by rule V1–V5 |
| datastore_failures | dstfail buckets + DF-terminal runs | |
| downstream_failures | TARGETFAIL terminals + captured HTTP classes | |
| cap_events | threshold notices + cap_suppressed bucket | validates §46 limit realism |

## 4. Latency Percentiles

Per-execution duration from executions API (start→last node). Report
p50 / p95 / p99 over the full window, split by outcome class (routed vs suppressed
vs dead-letter). Proposed reference: p95 < 10 s for routed events (route timeout is
10 s; sustained p95 near timeout indicates destination strain).

## 5. Operator Workload Measurement

- Dead-letter triage: count + analyst minutes (time-stamped triage notes) per day;
- Notice volume: threshold/operator notices emitted (target ≤ a handful/day);
- Kill-switch drills: zero planned inside the window (contamination of metrics).

## 6. FP Sampling Method (per ROUT-39-02 §4 adaptation)

1. Daily at fixed UTC time: sample min(50, total_routed) routed alerts, uniformly
   random by source_ref.
2. Each sampled alert gets analyst disposition: correct-detection / false-positive /
   benign-but-true / unclassifiable (with one-line rationale).
3. Sampling tooling records seed + selection list into evidence dir (reproducible).

## 7. Case-Quality Rubric (each routed/sampled case graded)

| Dimension | Grade criteria |
|---|---|
| Title compliance | exact `[p40-test] suricata sid <n>` format |
| Tag completeness | contains `packet,suricata,sid:<n>,class:packet,test:p40` |
| Field fidelity | source_ref/timestamp match originating event |
| Dedup correctness | no duplicate rows for same tuple within a bucket; no wrongful suppression observed in window logs |
| Isolation cleanliness | zero non-test-tagged rows attributable to lane |

Case quality score = fraction of sampled cases passing ALL dimensions; computed per
day and window-wide.

## 8. Acceptance Thresholds (proposed — confirm at window kickoff, then frozen)

| # | Threshold | Proposal |
|---|---|---|
| T1 | FP rate (sampled) | < 5% false-positive dispositions |
| T2 | Delivery success (routed attempts) | ≥ 99% excluding injected-fault windows |
| T3 | Malformed share | < 1% of total executions |
| T4 | Contamination findings (ISO-40-01 C1–C5) | 0 findings |
| T5 | Latency | p95 < 10 s routed |
| T6 | Operator load | < 15 min/day dead-letter triage |
| T7 | Cap realism | cap_events observed but ≤ 1 sustained-breach hour |

Sustained breach of any threshold ⇒ auto-disable candidate review (K2 switch),
not silent continuation.

## 9. Reporting Obligations

Successor report carries: hourly metric table, percentile block, sampling list +
dispositions, rubric scores, threshold scoreboard, raw exports under
`ops/evidence/p40-packet-runtime/volwindow/` (hashed). Empty-until-run policy
applies to every number.

## Verdict

**VOL-PKT-01: BLOCKED-RUNTIME — PLAN COMPLETE, OBSERVATION IMPOSSIBLE UNTIL LANE
CERTIFICATION.** Feeds ROUT-PKT precondition P6 directly.
