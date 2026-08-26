# Phase 40 Mapped-Fields Baseline

**Report ID:** phase40-07-mapped-fields-baseline
**Phase:** 40
**Title:** Phase 40 Mapped-Field Baseline on 2026.08.26 — Deep Leaf Count 1580→1604, Branch Accounting, Growth Trajectory vs the 2000 Budget
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:57:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (guardrail WARN active from day one)
**Claims:** VERIFIED (MEASURED)
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-07-mapped-fields-baseline.md`

---

## 1. Method — CORRECT Deep Counter

Prior-phase counts sometimes stopped at first-level objects. This arc uses a recursive
properties walk that counts every leaf (including multi-field subfields), run against
the live `_mapping`:

```python
# core of ops/scripts/p40-field-growth-check.sh / inline counter
def walk(node, path):
    for k, v in node.items():
        p = f"{path}.{k}" if path else k
        if "properties" in v: walk(v["properties"], p)
        elif "fields" in v:
            leaves.append(p)
            for mk in v["fields"]: leaves.append(f"{p}.{mk}")
        else: leaves.append(p)
```

## 2. Independent Cross-Check (planner agreement)

A wildcard full-text query on this index failed with:

```
"reason" : "field expansion for [*] matches too many fields, limit: 1024, got: 1580"
```

The query planner's own field census says **1580**; my walk said **1580** at the same
minute. Two independent mechanisms agree exactly.

## 3. Results (MEASURED)

```
$ python3 p40-leaf-count.py wazuh-archives-4.x-2026.08.26     (~01:40Z)
INDEX wazuh-archives-4.x-2026.08.26
LEAF_FIELDS 1580
BRANCH data 1513
BRANCH rule 27
BRANCH GeoLocation 8
BRANCH agent 6
BRANCH predecoder 6
BRANCH cluster 4
BRANCH decoder 4 … (+ small remainder)
```

```
$ ops/scripts/p40-field-growth-check.sh                        (01:47Z)
p40-field-growth index=wazuh-archives-4.x-2026.08.26 leaf_fields=1604 limit=2000 verdict=WARN growth_per_day=n/a
branches: data:1537 rule:27 GeoLocation:8 agent:6 predecoder:6 cluster:4
```

| Metric | Value | Note |
|---|---|---|
| Leaf fields @H+1.6h | **1580** | == planner census |
| Leaf fields @H+1.8h | **1604** | +24 in ~20 min during early-day burst |
| `data.*` subtree | 1513–1537 (**≈95%**) | dominant contributor as designed |
| Old ceiling (P38 era) | saturated at 999–1000 | now released |
| Budget used | **79–80% of 2000 at H+1.8h** | soft threshold already crossed |

## 4. Dynamic Mapping Behavior and Trajectory

Growth is event-class-driven: each new `data.<integration>.<field>` path maps on first
sight. The early spike is dominated by the ubiquiti kick-noise class (14,912 docs with
`data.ubiquiti.kick_mac` by 01:39Z) plus windows/audit/docker classes; rarer decoders
(syscheck/aws/virustotal/ms-graph/sca = 0 today) will add their branches only if they
fire. Honest trajectory statement: **pace at capture ≈ up to ~1.7k fields/day if the
burst rate held, but burst rates decay as decoders saturate; the H+6 and EOD script
runs decide.** The guardrail exists precisely because this number is not assumable.

## 5. Operational Caveat Discovered

With mapped fields > 1024, wildcard/`q=` queries hit OpenSearch's default field-
expansion cap (`limit: 1024`) and FAIL even though indexing is healthy:

```
_count?q=suricata → "field expansion for [*] matches too many fields, limit: 1024, got: 1580"
```

This predates the fix in effect (old indices exceeded 1024 too once saturated) but is
now a PERMANENT property of archive indices. Dashboards/detectors must use explicit
fields or raise `indices.query.bool.max_clause_count`. Logged to risks sync (phase40-00 §5).

## 6. Threshold Recommendation (per P39 design)

Soft **1400 WARN** / hard **1800 CRIT** vs limit 2000 — implemented verbatim in
`ops/scripts/p40-field-growth-check.sh`; current state = WARN. If EOD lands >1800,
escalate to phase40-12 containment design instead of another silent bump.

## 7. Verdict

**COMPLETE.** Baseline established with dual-method agreement; headroom real but
thinner than assumed; guardrail live and already warning.
