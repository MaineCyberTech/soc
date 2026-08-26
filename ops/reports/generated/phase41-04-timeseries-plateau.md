# Phase 41 Timeseries — Three-Sample Plateau

**Report ID:** phase41-04-timeseries-plateau
**Phase:** 41
**Title:** Phase 41 Field-Growth Timeseries — 1604→1706→1706→1706 Plateau Across Three Samples, Method and Interpretation
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:56:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-04-timeseries-plateau.md`

---

## 1. Method

Samples come from the P40 guardrail script (`ops/scripts/p40-field-growth-check.sh`),
which fetches today's `_mapping` from the live indexer and deep-counts leaves with a
recursive properties walk (raw basis: multi-field variants counted; see phase41-00 §5).
Each run appends `ts<TAB>count` to the canonical trend state:

```
/opt/mct-security-stack/ops/evidence/p40-field-growth-state.tsv
```

and a full line to `/opt/mct-security-stack/ops/reports/p40-field-growth.log`.
Sampling was manual during this arc (the guardrail's schedule continues independently).

## 2. The Series (MEASURED, verbatim state + log)

| Sample (UTC) | leaf_fields (raw) | growth_per_day | verdict | data.* branch | Note |
|---|---|---|---|---|---|
| 01:44:18Z | 1604 | n/a | WARN | 1537 | P40-era reading carried in |
| 02:43:38Z | **1706** | 2448.0* | WARN | 1637 | last growth sample |
| 03:05:17Z | **1706** | **0.0** | WARN | 1637 | plateau begins |
| 03:38:34Z | **1706** | **0.0** | WARN | 1637 | plateau confirmed |
| 04:41:27Z | 1766 | 1374.0* | WARN | 1697 | post-containment residual (see §5) |

\* daily-rate artifacts of the script's min-window clamp over sub-day deltas — not
real velocities. The meaningful velocity signal is the pair of exact `0.0` rows.

## 3. What the Plateau Means

Three samples at exactly 1706 across ~55 minutes (02:43 → 03:38) with zero new mapped
leaves is the signature of a **closed vocabulary**: every event class that will appear
today had already appeared. Dynamic mapping only grows on FIRST appearance of a path;
steady-state traffic reuses existing paths and cannot grow the count.

This reframes the P40 WARN: the danger was never unbounded daily growth — it was the
per-index-birth **vocabulary size**, dominated by one producer class (stats, 441 of
1637 data-leaves ≈ 27% of everything, phase41-06). Containment must therefore shrink
the vocabulary, not throttle a rate.

## 4. Cross-Check Against Document Flow

During the plateau window the pipeline kept indexing hundreds of thousands of docs
(288,875 archives docs by 04:49Z) including continued stats events until cutover —
last full-stats document indexed **03:53:31.766Z** (MEASURED, exists-filter max
@timestamp). So the plateau is NOT "traffic stopped"; it is "no NEW field paths",
proving the counter methodology tracks vocabulary rather than volume.

## 5. The 04:41 Post-Containment Reading (+60) Decomposed

The fresh sample after containment apply reads 1766 raw (+60 vs plateau). Honest
decomposition:

| Component | Δ raw (approx) | Nature |
|---|---|---|
| Compact lane (by design) | ~+34–40 | 16 whitelisted aliases + detect_engines subtree (5 leaves) + sensor/event_type metadata, most with .text/.keyword multi-fields on string paths |
| Windows family tail | ~+16 | win grew 77→85 unique between attribution snapshot and fresh walk (slow trickle continues — phase41-11) |
| Residual pre-cutover stats tail | ~+0–8 | final stats docs (≤03:53:31Z) mapped no new stat paths — stats set was complete by 02:43 |
| Sum | ≈ +60 | matches measured delta |

Key honesty point: containment did NOT shrink today's count and cannot — Elasticsearch
mappings are append-only for an index's lifetime. It eliminates tomorrow's 877-raw /
441-unique contribution at birth. Today's number only ever goes up; the certification
therefore keys on the NEXT index (phase41-17, phase41-18).

## 6. Projection Hook

Using the plateau as base and removing the stats vocabulary at birth gives the 08.27
projection developed in phase41-17 §5: planning estimate ≈1285 (conservative,
mixed-basis upper bound), corrected raw-basis central estimate ≈900 ±150. Both far
below soft 1400. First guardrail run tomorrow adjudicates.

## 7. Sampling Context Per Row (what the stack was doing)

| Sample | Simultaneous reality |
|---|---|
| 01:44:18Z | P40 arc tail; early-day burst complete; stats lane emitting normally |
| 02:43:38Z | vocabulary complete (1706); heavy steady ingest both lanes |
| 03:05:17Z | identical map — first zero-velocity proof |
| 03:38:34Z | identical map again; containment design work starting |
| (03:53:31Z) | LAST full-stats document ever indexed (between samples) |
| (≈03:55:59Z) | production Suricata restart with stats type removed |
| 04:41:27Z | post-containment sample; compact lane live ~45 min |

The two "identical" rows bracket a fully-loaded pipeline — hundreds of thousands of
documents indexed between them — which is what elevates this from anecdote to
measurement.

## 8. Method Pseudo-Code (for reproducibility)

```python
# core of ops/scripts/p40-field-growth-check.sh (raw basis)
def walk(node, path):
    for k, v in node.items():
        p = f"{path}.{k}" if path else k
        if   "properties" in v: walk(v["properties"], p)
        elif "fields"     in v:                 # multi-field parent
            leaves.append(p)
            for mk in v["fields"]: leaves.append(f"{p}.{mk}")  # raw counts variants
        else: leaves.append(p)
```

Unique-basis variant used for branch attribution omits the multi-field expansion loop.
Cross-index comparisons must always state which variant produced the number.

## 9. Conclusion

The plateau was real, measured thrice, and mechanistically explained. It converted the
P41 problem from "runaway growth" to "bloody birth certificate" — and birth certificates
can be rewritten by changing what gets emitted at source.
