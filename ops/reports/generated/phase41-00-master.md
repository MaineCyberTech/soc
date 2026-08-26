# Phase 41 Master Orchestrator — Field-Growth Containment Arc

**Report ID:** phase41-00-master
**Phase:** 41
**Title:** Phase 41 Master Orchestrator — Field-Growth Containment Arc Scope, Execution Order, Gate Map, and Verdict Approach (Prompts 00–18)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:52:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-00-master.md`
**Retention Class:** LONG

---

## 1. Purpose

Phase 41 is the **field-growth containment arc**: the operational answer to the WARN
state that Phase 40 left open. Phase 39 built the template ceiling (limit 2000),
Phase 40 proved it works and instrumented growth (`p40-field-growth-check.sh`,
soft 1400 / hard 1800), and P40 closed with fields still climbing toward the budget.
P41 measures the real growth curve, attributes every branch to its producing source,
designs and applies containment for the dominant branch (`data.stats`, the Suricata
full-stats lane), certifies the result **CONTAINED-PENDING-FULL-CYCLE**, and arms the
flip condition that turns the certification VERIFIED after tomorrow's index birth.

Live-verified window: **2026-08-26 03:38–04:51 UTC**, plus fresh re-measurement during
report production (04:41–04:51 UTC). All numbers in this corpus are MEASURED against
the live stack unless explicitly marked ESTIMATE/PROJECTED. No secret values appear
anywhere; credentials render as `[REDACTED-*]` per `docs/SECRET-HANDLING.md`.

## 2. Headline Results (arc rollup)

| # | Result | Evidence |
|---|---|---|
| 1 | Morning rejection spike was a **FALSE ALARM**: all rejections pre-cutover (23:53–00:00 window), zero since | phase41-01, phase41-03 |
| 2 | Mapped fields hit a **PLATEAU at 1706 raw** across three samples (02:43/03:05/03:38Z), `growth_per_day=0.0` | phase41-04 |
| 3 | Dominant branch fully attributed: `data.stats`=441 unique leaves, producer 100% agent 016 `mct-packet-sensor` | phase41-06, phase41-07 |
| 4 | Containment applied after two failed YAML attempts and a **dual-process discovery** on the sensor | phase41-10, phase41-15 |
| 5 | Final design: drop `stats:` from EVE types + unix-command socket + compact-stats emitter (16 whitelisted counters) + systemd timer + Wazuh localfile | phase41-13, phase41-15 |
| 6 | Post-apply proof: zero full-stats events indexed post-restart; compact lane proven end-to-end (43 docs by 04:49Z); alerts unaffected; kernel drops 0 | phase41-16 |
| 7 | Steady-state field impact: ≈ **−425 leaves/index-lifetime** (441 removed, ~16–22 added by the compact lane) | phase41-08, phase41-12 |
| 8 | Certification: **CONTAINED-PENDING-FULL-CYCLE**, limit unchanged 2000 per policy | phase41-18 |

## 3. Scope

The arc covers 19 prompts (phase41-00…phase41-18):

### Arc A — Measurement & attribution (read-only)

| # | Item | Report |
|---|---|---|
| A1 | Preflight state freeze incl. false-alarm catch | phase41-01 |
| A2 | Change register G41-01..14 | phase41-02 |
| A3 | Guardrail morning reading + false-alarm resolution | phase41-03 |
| A4 | Three-sample plateau timeseries + method | phase41-04 |
| A5 | Name diff vs prior-day families | phase41-05 |
| A6 | Branch accounting (unique-leaf breakdown) | phase41-06 |
| A7 | Source correlation per family | phase41-07 |
| A8 | Value classification (evidence vs noise) | phase41-08 |
| A9 | Consumer audit (who uses stats fields) | phase41-09 |

### Arc B — Containment design & decision

| # | Item | Report |
|---|---|---|
| B1 | Stats containment design (journey + dual-process discovery) | phase41-10 |
| B2 | Windows branch assessment (NOT contained; trigger set) | phase41-11 |
| B3 | Options comparison matrix | phase41-12 |
| B4 | Final selected plan spec | phase41-13 |

### Arc C — Apply & verify

| # | Item | Report |
|---|---|---|
| C1 | Lab test (`-T` config test + first compact line) | phase41-14 |
| C2 | Full apply record (edits/backups/mask/restart/localfile/timer) | phase41-15 |
| C3 | Postcheck (zero full-stats, compact indexed, alerts healthy) | phase41-16 |

### Arc D — Certification

| # | Item | Report |
|---|---|---|
| D1 | Plateau window continuation + 08.27 projection | phase41-17 |
| D2 | Risk certification CONTAINED-PENDING-FULL-CYCLE | phase41-18 |

## 4. Execution Order and Dependencies

```
A1 ─ A2 ─ A3 ─ A4 ─ A5 ─ A6 ─ A7 ─ A8 ─ A9      (measurement; no mutations)
                  │
                  ├── B1/B2 (design) ── B3 (decision matrix) ── B4 (plan)
                  │
                  └── C1 (lab) ── GATE ── C2 (apply) ── C3 (postcheck)
                                           │
                                           └── D1 (window) ── D2 (certification)
```

Hard gate between C1 and C2: apply proceeded only after `-T` config test passed AND
a first compact line validated from the command socket path (phase41-14 §2–3).

## 5. Method Notes Carried Across the Corpus

- **Deep leaf counter**: recursive `_mapping` properties walk, same core as
  `ops/scripts/p40-field-growth-check.sh` (G40-07 lineage). Two counting bases are
  distinguished everywhere in P41:
  - **raw** — multi-fields (`.text`/`.keyword` variants) counted as extra leaves;
    this is what the guardrail script reports (1604→1706→1766 series);
  - **unique** — multi-field-collapsed leaf count; this reproduces the P41 branch
    attribution figures exactly (stats=441, ubiquiti=36, parameters=35 …).
  Both bases are shown side-by-side in phase41-06 §3; mixing them was the single
  largest analysis trap of this arc (see phase41-17 §4).
- **Rejection forensics**: `docker logs --timestamps` on indexer containers,
  minute-bucketed histograms; rejection signature
  `Limit of total fields [1000] has been exceeded` (pre-template default era).
- **Producer attribution**: exists-filter + terms aggregation on `agent.name.keyword`
  per family (phase41-07 §2).

## 6. Gate Map (summary; detail in phase41-02)

| Gate | Subject | Outcome |
|---|---|---|
| G41-01 | Sensor config change (eve.json types) | APPLIED |
| G41-02 | systemd unit mask (duplicate prevention) | APPLIED |
| G41-03 | Production process restart (exact args) | APPLIED |
| G41-04 | Unix-command socket enablement | APPLIED |
| G41-05 | Compact-stats emitter install | APPLIED |
| G41-06 | Timer/service scheduling | APPLIED |
| G41-07 | Endpoint localfile + agent restart (016) | APPLIED |
| G41-08 | Archives lane validation (compact docs indexed) | VERIFIED |
| G41-09 | Packet import (none this arc) | N/A |
| G41-10 | Dashboard validation (no stats-based dashboards) | VERIFIED-NONE |
| G41-11 | Release custody (artifacts backed up) | APPLIED |
| G41-12 | Rollback armed (yaml.bak-p41-containment) | DOCUMENTED |
| G41-13 | Corpus commit/push | PENDING sign-off |
| G41-14 | Certification flip condition (08.27 re-check) | ARMED |

## 7. Verdict Approach

D2 certifies **CONTAINED-PENDING-FULL-CYCLE**, not VERIFIED: the source is eliminated
and the replacement lane is proven end-to-end today, but a field-count claim is only
as good as its next index birth. The verdict flips to VERIFIED iff the first
`p40-field-growth-check.sh` run on `wazuh-archives-4.x-2026.08.27` lands below the
projected band (phase41-17 §5). Limit stays 2000 per policy — no threshold edits were
made or proposed in P41.

## 8. Sync Obligations

- AGENTS.md blocker line for field growth: remains WARN-tracked; flip wording deferred
  to post-08.27 verification (same discipline as P40's phase40-13 flip record).
- `ops/evidence/p40-field-growth-state.tsv`: continues as the canonical trend state;
  P41 appends rows only via the existing guardrail script (no format changes).
- Catalog rows for phase41-00…18 registered alongside commit gate G41-13.
