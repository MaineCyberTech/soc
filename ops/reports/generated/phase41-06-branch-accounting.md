# Phase 41 Branch Accounting

**Report ID:** phase41-06-branch-accounting
**Phase:** 41
**Title:** Phase 41 Branch Accounting — data.stats=441 Dominates; Full Unique-Leaf Breakdown With Raw/Unique Reconciliation
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:58:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-06-branch-accounting.md`

---

## 1. Purpose

Attribute every mapped leaf on `wazuh-archives-4.x-2026.08.26` to its top-level and
second-level branch, establishing exactly where the 1706 (raw) / ~892–923 (unique)
field budget went — the prerequisite for deciding what to contain.

## 2. Top-Level Branches (MEASURED)

| Branch | Raw | Unique | Share of unique |
|---|---|---|---|
| data.* | 1697 | 854 | ~92% |
| rule | 27 | 27 | 3% |
| GeoLocation | 8 | 8 | <1% |
| agent | 6 | 6 | <1% |
| decoder / predecoder | 6+6 | 6+6 | ~1% |
| cluster, full_log, id, input, location, manager | 2 each | 2 each | ~2% |
| @timestamp, timestamp | 1+1 | 1+1 | — |
| **Total** | **1766 raw** | **~892–923 unique*** | 100% |

\* two unique-basis tallies in this corpus differ slightly by traversal edge cases
(854 data + 69 non-data = 923 via per-branch walk; 892 via set-diff dedupe). Both are
stated; neither changes any decision.

## 3. The Two Counting Bases — Reconciliation Table

Raw counting adds one leaf per multi-field variant (`.text`/`.keyword`). Measured
pairs on the biggest families:

| Family | Unique | Raw | Multi-fielded |
|---|---|---|---|
| data.stats | 441 | 877 | ≈436 |
| data.win | 85 (77 at morning snapshot) | 168 | 83 |
| data.ubiquiti | 36 | 72 | 36 |
| data.parameters | 35 | 69 | 34 |
| data.audit | 30 | 60 | 30 |
| data.service | 30 | 60 | 30 |
| data.osquery | 28 | 56 | 28 |

Every P41 branch-attribution figure quoted anywhere (including the arc brief) is the
unique basis; every guardrail threshold reading is raw. phase41-17 §4 documents the
one place this mattered analytically.

## 4. data.stats Internal Breakdown (unique leaves)

| Sub-branch | Leaves | What it is |
|---|---|---|
| stats.decoder | **165** | protocol/encap counters per decoder |
| stats.app_layer | **157** | per-protocol app-layer tx counters |
| stats.flow | 54 | flow manager counters |
| stats.tcp | 27 | TCP segment/stream reassembly |
| stats.capture | 10 | kernel packets/drops/errors |
| stats.detect | 8 | engine alerts/alert_queue |
| stats.flow_bypassed | 7 | bypassed-flow counters |
| stats.defrag | 5 | fragment tracking |
| stats.ftp / stats.http | 2+2 | memuse |
| file_store, memcap_pressure, memcap_pressure_max, uptime | 1 each | singles |
| **Total** | **441** | |

The long tail is structural: Suricata's EVE stats event carries its ENTIRE enabled
counter set every interval, so all 441 map within hours of index birth regardless of
traffic mix. That single fact explains most of P40's "burst".

## 5. Remaining data.* Families (unique)

| Family | Leaves | Family | Leaves |
|---|---|---|---|
| process | 28 | netinfo | 22 |
| unifi | 19 | os | 14 |
| port | 11 | flow | 8 |
| alert | 7 | hardware | 7 |
| detect_engines | 5 (compact lane) | docker | 2 |
| origin | 2 | MCT_SYNTHETIC / MCT_TEST_ID | 1+1 |

## 7. Non-Data Top-Level Branches (stable schema)

| Branch | Leaves | Character |
|---|---|---|
| rule | 27 | Wazuh rule metadata (id, description, groups, firedtimes…) — core, never a candidate |
| GeoLocation | 8 | geo enrichment on external IPs (city/country/location…) |
| agent | 6 | agent identity block |
| decoder / predecoder | 6 + 6 | pre-decoder chain metadata |
| cluster | 4 | multi-node provenance (name/node) |
| full_log / id / input / location / manager | 2 each | document envelope |
| @timestamp / timestamp | 1 + 1 | time envelope |

Sum: ~69 raw leaves of fixed schema. The variable universe is data.* alone.

## 8. Budget Projection Table (steady state after containment)

| Scenario | Raw leaves | vs soft 1400 | vs limit 2000 |
|---|---|---|---|
| Today (actual, stats era) | 1766 | +366 over | −234 under |
| Tomorrow projection, corrected basis (phase41-17 §4) | ≈900 ±150 | ≥350 headroom | ≥950 headroom |
| Tomorrow projection, conservative mixed basis | ≈1285 | ≥115 headroom | ≥715 headroom |
| Win-trigger trip (R-2 fires) added on top | +~130 worst case | still <1400 | still <2000 |

Even the pessimistic row keeps every threshold intact — the reason no policy change
was requested anywhere in this arc.

## 9. Counting-Method Appendix

- **Raw**: `p40-field-growth-check.sh` behavior; counts `p` AND each `p.<multi-field>`
  variant. Owns: guardrail series continuity (P40→P41), thresholds.
- **Unique**: leaf paths with multi-field families collapsed to their base path. Owns:
  family attribution, this report's tables, the arc brief's figures.
- Rule of record going forward: any number crossing reports carries its basis label
  (enforced in phase41-17 §4 lesson and phase41-18 R-5).

## 10. Decision Consequence

1. **stats (441)** → contained this phase at source (phase41-10/13/15); replacement
   compact lane costs ~16–22 leaves (phase41-12 §3).
2. **win (85→ growing)** → NOT contained this phase; below materiality vs remaining
   budget but monitored with an explicit trigger (>150) — phase41-11.
3. Everything else sums to ~330 unique and is either core Wazuh schema (rule, agent,
   GeoLocation…) or modest, bounded integrations — accepted as-is.

Budget math after containment, steady state: ~923 − 441 + ~20 ≈ **~500 unique**
(≈850–950 raw) against limit 2000 → comfortable headroom restored without touching a
single threshold value.
