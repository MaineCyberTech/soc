# Phase 42 FP Population Check — FP-POP-42-01

**Report ID:** phase42-74-fp-population-check
**Phase:** 42
**Title:** Fresh Rolling-7d Universe Rerun: 10 Alerts (8 Canary-Marked / 2 Natural), Zero NEW Natural SIDs, Zero Repeat Offenders — Scheduled Phase-42 Trigger Satisfied And Resolved By This Check; ≥50-Natural And Repeat-Offender Triggers Both NOT FIRED → Outcome CONTINUE-QUALITATIVE
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:31:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-74-fp-population-check.md`

---

## 1. Purpose

First scheduled continuation of the P41 false-positive framework (FP-BASE-41-01,
phase41-74): rerun the universe query live, split canary vs natural by the MCT
marker method, and evaluate both population triggers from phase41-71 §4.

## 2. Live query — VERIFIED (run 2026-08-26T~09:27Z)

Query against the indexer (`wazuh-alerts-*`):

```json
{"query":{"bool":{"filter":[{"term":{"rule.groups":"suricata"}},
 {"range":{"timestamp":{"gte":"now-7d","lte":"now"}}}]}},"size":50}
```

Response (trimmed):

```json
{"took":14,"timed_out":false,
 "_shards":{"total":60,"successful":60,"skipped":0,"failed":0},
 "hits":{"total":{"value":10,"relation":"eq"}}}
```

**Fresh universe = 10 alerts**, rolling 7 days ending 2026-08-26T09:27Z,
60/60 shards successful. Snapshot stored as
`ops/evidence/p42-fp-sampling/universe-rolling7d-20260826.json`
(sha256 `059b94185b69fa39de99de2789095e5838a352be0604c71a4e98aecd3f6cece6`,
12,439 bytes).

## 3. Canary/natural split — VERIFIED

Method per phase41-70 §2: an alert is **canary-marked (synthetic)** iff
`rule.description` contains the literal substring `MCT-CANARY`; classification
is a deterministic local post-processing check on retrieved documents.

Method note: an index-side `bool.must_not.match_phrase` exclusion attempt on
`rule.description` returned the unfiltered 10-doc set (field-analyzer behavior),
so separation was performed by the documented literal-substring check — which is
the method of record; the query-level shortcut is NOT relied upon.

| Class | Count | Detail |
|---|---|---|
| Canary-marked synthetic | **8** | All sid 2027967: markers `[MCT-CANARY-P40-E2E-002…007]` visible + 2 HTTP-request-description variants (Aug-25 18:14:27Z, Aug-26 01:07:35Z) carrying markers deeper in the description |
| Natural candidates | **2** | See §4 |

## 4. Natural population — VERIFIED

| # | Timestamp (UTC) | SID | Signature | src → dst | Status vs P41 |
|---|---|---|---|---|---|
| N1 | 2026-08-25T19:18:18Z | **2260001** | SURICATA Applayer Wrong direction first Data | 172.183.7.192 → 192.168.111.108 | SAME event as P41 N1 (identical timestamp); verdict UNKNOWN-benign-leaning unchanged |
| N2 | 2026-08-25T17:53:54Z | **2210038** | SURICATA STREAM FIN out of window | 192.168.111.144 → 192.168.111.1 | SAME event as P41 N2 (identical timestamp); verdict UNKNOWN-benign-leaning unchanged |

**NEW natural SIDs since baseline: NONE.**

## 5. Delta vs P41 baseline (12 alerts = 8 marked + 4 natural)

- Total 12 → **10**: the two sid **2100366** GPL ICMP PING \*NIX events
  (2026-08-18/19) **aged out of the rolling window** — expected decay, not a
  detection change.
- Canary-marked steady at 8.
- Natural 4 → **2** solely by window aging of already-classified events.
- Zero new sids, zero recurrences of parked candidates.

## 6. Trigger evaluation (phase41-71 §4)

| Trigger | Threshold | Observed | Verdict |
|---|---|---|---|
| Population trigger | ≥50 natural alerts in universe | 2 natural | **NOT FIRED** |
| Repeat-offender trigger | Same SID ≥3 natural occurrences / rolling 7d | Max natural SID count = 1 | **NOT FIRED** |
| Scheduled review | Phase-42 open | This check | **FIRED — satisfied by this report** |

## 7. Outcome

**CONTINUE-QUALITATIVE.** No statistical claims made or permitted downstream
(phase41-69 §6 stop-condition still in force). Continuation record:
phase42-75-fp-continue.md. Tuning decision: phase42-76-rule-tuning-decision.md.
