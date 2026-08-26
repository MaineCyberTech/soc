# Phase 38-39: Metric Consistency Review

**Title:** Phase 38-39: Metric Consistency Review
**Report ID:** phase38-39-metric-consistency
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-39-metric-consistency.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)

---

## 1. Purpose

Find inconsistent counts and units across reports and compare cited figures to live state (2026-08-25): 1,833 .md report files; 7 active agents (000,006,007,011,012,014,016); 274 shards GREEN / 3 nodes; 22 alert indices; 11 archive indices; 796 Shuffle executions.

---

## 2. Metric-by-Metric Reconciliation

### MCY-01: Report corpus counts — DIVERGENT

| Figure | Source | Notes |
|---|---|---|
| 1,831 .md | `generated/phase38-04-report-inventory.md:19` (+1,856 total, :18) | Accurate at write time |
| 1,833 .md / 1,860 total | Live `ls` census 2026-08-25 | +2 reports since inventory (this phase's early writes); non-md now 27 vs 25 (:20) |
| 1,877 "canonical files" across 3 roots | `generated/phase38-03-report-root-discovery.md` §Summary | **Unreconciled**: exceeds root-level total by ~21–27 depending on snapshot; double-count or stale sub-root cache suspected |
| 1,650 phase-reports class sum | `generated/phase38-04…` §8 artifact table (:254) | Class table self-consistent but predates current files |

Verdict: every summary quoting a corpus count MUST timestamp it. The 1,877 figure needs re-derivation before use anywhere.

### MCY-02: Agents — CONFLICT IN CATEGORIZATION, AGREEMENT IN TOTALS

| Figure | Source |
|---|---|
| 7 active | Live fleet list; `phase36-75-final-report.md:67`; `phase37-81-final.md:149` |
| "3 retired" / "3 retired/disconnected" / "Disconnected: 3 (008-retired,…)" | `generated/phase38-00-master.md:117`; `phase36-75-final-report.md:68` |
| Canonical split 7 active / 2 disconnected (013,015) / 1 retired (008) | `phase37-81-final.md:77-83` detail rows |

Totals agree (10 tracked endpoints); labels disagree. Units problem: agent states merged into one bucket in summaries.

### MCY-03: Shards/nodes — CONSISTENT

274 shards, 3 nodes, GREEN: live state = `phase37-81-final.md:142-147` Cluster Summary = `generated/phase38-00-master.md:105-107`. No drift detected. (ES API not reachable from the audit shell this run; three-way agreement taken as corroborated.)

### MCY-04: Archive indices & retention sizes — INTERNALLY INCONSISTENT UNITS

| Figure | Source |
|---|---|
| 11 archive indices attached | `phase36-75-final-report.md:13`; confirmed by `generated/phase38-79-retention-verification.md` §3 table (2026.08.15→08.25) |
| ~7.9GB expected relief from indices 08-15..18 | `phase36-75-final-report.md:15`; `phase37-46-retention-relief.md:15` |
| Total primary store of all 11 archives ≈ 8.7GB | `generated/phase38-79-retention-verification.md` §3 |

Check: 932.4MB+649.9MB+1.2GB+1.0GB ≈ 3.76GB for 08-15..18 per the 38-79 table — materially below the ~7.9GB forecast for those four indices. Either the forecast counted replica data/melted totals or was estimated pre-measurement. **The ~7.9GB figure is currently unsupported by the best available per-index table; treat relief forecast as unvalidated (cross-ref phase38-33 UNV-04).**

### MCY-05: Field error counts — GROWING SERIES, MIXED WINDOWS

| Figure | Window | Source |
|---|---|---|
| 15,189 cumulative | P36 baseline | `phase36-29-field-cardinality-baseline.md`; quoted at `phase36-75-final-report.md:29` |
| 18,849 cumulative | Post-P37 restart | `phase37-38-field-postlogs.md` context; `phase37-81-final.md:48` |
| "~100/min" rate | both eras | `phase37-38…:11`; live state |
| 1,281 vs 1,830 "current window" | different log windows (P38-01 vs 37-38 18-min sample) | `generated/phase38-01-preflight.md:116`; `phase37-38-field-postlogs.md:12` |

Not contradictory once windows are stated — but two reports quote window counts without units/timeframe, which reads as disagreement. Rule: error metrics always as `rate/min + cumulative + window length`.

### MCY-06: Workflows/executions — CONSISTENT WITH ONE OUTLIER

2 workflows, 796 executions, all healthchecks: `phase36-16-shuffle-evidence-bundle.md` E4; `phase36-75-final-report.md:22`; `phase37-81-final.md:26-28`; `generated/phase38-01-preflight.md:127-138`. Outlier: "No workflows to back up" (`final-phase35-operator-report-20260825-1841Z.md:54`) — superseded (see phase38-32 STALE-07). Alert-index count (22) appears in operational dashboards rather than prose; no contradicting prose figure located.

### MCY-07: Disk/memory figures — SOURCE-VARIANCE

| Metric | Values seen | Live |
|---|---|---|
| Disk % | 85% (early P36) → 84% (119G/148G, P37 final :99) → master "118G/148G" (`phase38-00-master.md:96`) | OS df: 117G/148G = 83% |
| Mem % | 78% (`phase36-75-final-report.md:64`) vs 75% (`phase37-81-final.md:110`) | 75% |
| Swap | 64% consistent everywhere | 64% |

OS-df vs ES-disk-stats differ by rounding/reserved blocks; 84% claims cite ES. Acceptable only when source is named.

### MCY-08: Phase 38 master internal totals — SELF-STALE

"Total: 10 reports, ~51 KB" and "executed 9 prompts" (`generated/phase38-00-master.md:241,19`) vs generated/ directory now containing 55 phase38 files. Snapshot semantics required.

### MCY-09: Suricata alert volume — SINGLE-SOURCE

1,095 alerts/day attributed to agent 016 stats events (`phase37-81-final.md:150`; `phase37-74-backlog.md` P2 #4). No second measurement exists; flagged single-source rather than inconsistent.

---

## 3. Summary Table

| ID | Metric | Status | Action |
|---|---|---|---|
| MCY-01 | Corpus counts | DIVERGENT (incl. unreconciled 1,877) | Timestamp all quotes; re-derive 1,877 |
| MCY-02 | Agent categorization | LABEL CONFLICT | 7/2/1 canonical triplet |
| MCY-03 | Shards/nodes | CONSISTENT | — |
| MCY-04 | Retention GB | FORECAST UNSUPPORTED (~7.9 vs ≈3.76 computed for same indices) | Recompute before citing |
| MCY-05 | Field errors | WINDOW AMBIGUITY | rate+cumulative+window rule |
| MCY-06 | Workflows/executions | CONSISTENT (1 superseded outlier) | — |
| MCY-07 | Disk/mem % | SOURCE-VARIANCE | Name measurement source |
| MCY-08 | Master self-totals | STALE SNAPSHOT | Snapshot semantics |
| MCY-09 | Alert volume | SINGLE-SOURCE | Add second measurement |

## 4. Recommendation

Add a `metric_provenance:` block to the report schema (`generated/phase38-07-report-schema.md`): value + unit + source command/index + capture timestamp. CI rejects bare integers for the metrics listed above.
