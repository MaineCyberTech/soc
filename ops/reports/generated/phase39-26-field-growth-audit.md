# Phase 39 Field-Growth Audit

**Report ID:** phase39-26-field-growth-audit  
**Phase:** 39  
**Title:** Mapped-Field Growth Audit — Saturation at the 1000 Ceiling Proven on 08.23–08.25, Branch Analysis, and Warning Thresholds  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:08:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-26-field-growth-audit.md`  
**Retention Class:** LONG

---

## 1. Purpose

Quantifies WHY rejections occur: the per-index mapped-field population of recent
archive indices versus the active limit of 1000, identification of high-cardinality
branches, and proposal of warning thresholds for the new 2000 regime.

## 2. Method

Leaf+object field walk over `_mapping` (counts every named entry in any `properties`
or multi-field `fields` dict — the same population the engine's total_fields counter
charges). Walker saved at `/tmp/opencode/fieldcount.py`; production copy embedded in
the phase39-22 script (C6).

```
$ curl -s -k -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-<D>/_mapping" | python3 fieldcount.py wazuh-archives-4.x-<D>
```

Counting caveat stated plainly: this is an approximation of engine semantics; there is
no direct API exposing "current fields / limit". The exactness check is behavioral —
see §3, where three independent days pin precisely at the boundary.

## 3. Results — MEASURED

| Index | TOTAL_FIELDS (walk) | Limit applied at its creation |
|---|---|---|
| wazuh-archives-4.x-2026.08.23 | **1000** | default 1000 |
| wazuh-archives-4.x-2026.08.24 | **999** | default 1000 |
| wazuh-archives-4.x-2026.08.25 | **999** | default 1000 |

Three consecutive daily indices saturate within one field of the ceiling. This is the
mechanism proof for the whole arc: mappings cannot grow past ~1000, so every document
introducing an unseen path is rejected with `Limit of total fields [1000]` — matching
the live error stream (≈150/min, phase39-21 §6).

## 4. High-Cardinality Branches — MEASURED (top branches per day)

```
2026.08.23: data.win 523 | data.ubiquiti 69 | data.service 61 | data.process 57
            data.sca 43   | data.unifi 39    | data.netinfo 30 | data.os 25
            data.port 23  | data.hardware 15 | rule.mitre 7   | data.virustotal 5

2026.08.24: data.win 519 | data.ubiquiti 63 | data.process 57 | data.sca 57
            data.unifi 39| data.netinfo 28  | data.virustotal 28 | data.port 23
            data.os 17   | data.hardware 15 | rule.mitre 7

2026.08.25: data.stats 547 ← NEW dominant branch today
            data.win 92  | data.ubiquiti 63 | data.process 57 | data.unifi 39
            data.netinfo 28 | data.port 23  | data.os 19     | data.flow 17
```

Findings:

1. **`data.stats` (547 fields) emerged as the day's dominant branch on 08.25.** This
   shape matches Suricata EVE `stats` events (hundreds of per-counter capture/decoder/
   flow fields emitted at fixed intervals). A single stats burst early in the day
   consumed over half the quota.
2. **Crowding-out is visible**: `data.win` mapped only 92 fields on 08.25 vs 519–523
   on prior days. Once `data.stats` filled the budget, later Windows event branches
   hit the wall first — explaining why rejections persisted all day rather than
   stopping after the burst.
3. Persistent heavy branches across all days: data.win, data.ubiquiti/data.unifi,
   data.process, data.sca, data.netinfo — the stable baseline demand is ≈450–550
   fields before bursts; bursts add 300–600 more. True daily demand therefore sits
   near or above the old 1000 line and plausibly above it once uncapped — tomorrow's
   EOD count on 08.26 is the first true-demand measurement (phase39-22 C6).

## 5. Growth-Rate Estimate

With every recent day pinned at the cap, marginal visible growth ≈0/day — the cap
masks true demand (this report's central limitation, resolved by tomorrow's uncapped
trajectory). Working estimate from branch structure:

- Stable core: ~500 fields/day
- Burst branches (stats/win-heavy days): +300–600
- Expected steady-state under limit=2000: **~900–1400**, i.e., 45–70% utilization —
  inside the proposed thresholds but with limited headroom for a second burst class.

## 6. Warning Thresholds Proposal

| Level | Value (of new limit 2000) | Action |
|---|---|---|
| OK | < 1400 | routine weekly audit only |
| SOFT (70%) | ≥ 1400 | identify top-growing branch; evaluate drop-fields/flatten for that branch (phase39-27 §4) |
| HARD (90%) | ≥ 1800 | mandatory strategy review within the week; consider flat-object mapping for burst branches or limit raise with capacity math |

## 7. Weekly Audit Task Definition

- Script: reuse phase39-22 C6 walk against each `wazuh-archives-4.x-*` index created
  in the trailing 7 days; emit table + threshold verdicts.
- Proposed location/schedule: `/opt/mct-security-stack/ops/jobs/field-growth-audit.sh`,
  Mondays 06:00Z; output appended to `ops/evidence/field-growth-<date>.log`, summary
  reported in the week's phase reports.
- Owner: MCT SOC. First run: 2026-08-31 (covers full first week under the new limit).

## 8. Verdict

**COMPLETE.** Root cause quantified and proven from live mappings: saturation at the
1000 ceiling on 08.23–08.25, with `data.stats` identified as the 08.25 quota-dominant
branch and crowding-out demonstrated (`data.win` 523→92). Thresholds and audit cadence
proposed; true-demand measurement carries to 08.26 (phase39-22 C6).
