# Phase 40 Field-Growth Guardrail

**Report ID:** phase40-11-field-growth-guardrail
**Phase:** 40
**Title:** Phase 40 Field-Growth Guardrail — Thresholds, Trend Formula, Delivery Script (Created + Executed), Alert Path and Containment
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:01:00Z
**Classification:** INTERNAL
**Status:** APPLIED
**Claims:** VERIFIED (script on-box, executed once, output embedded)
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-11-field-growth-guardrail.md`

---

## 1. Design

| Element | Value | Origin |
|---|---|---|
| Effective limit | 2000 leaf fields | fieldlimit template (proven phase40-06) |
| Soft threshold | **1400 → WARN**, exit 1 | P39 design (phase39-26 §7) |
| Hard threshold | **1800 → CRIT**, exit 2 | P39 design |
| Daily-growth trend formula | `growth/day = (count_now − count_prev) / max(elapsed_days, 1h)` from state file rows | this report |
| Top-branch accounting | top-6 `data./rule./…` subtree leaf counts per run | this report |
| Owner | MCT SOC | phase39-28 §5 |
| State/log sinks | `ops/evidence/p40-field-growth-state.tsv`, `ops/reports/p40-field-growth.log` | convention-aligned |

## 2. Delivery Vehicle — script CREATED (APPLIED)

`/opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh` (mode 755):
sources creds by PATH only (never echoes values), takes optional index arg
(default = today's archive index), recursive leaf walk, threshold verdict,
trend delta vs previous state row, appends monitor log + state row.
Closes GAP-40-A (P39's `ops/jobs/fieldlimit-proof-capture.sh` was never materialized).

## 3. Runbook Reference and Scheduling

- Ref: phase40-07 §6 (threshold rationale), phase40-12 §3 (containment if CRIT),
  AGENTS.md "Known Blockers" pointer (updated this arc).
- Schedule: daily 06:00Z cron recommended (`ops/scripts/p40-field-growth-check.sh`
  exit codes are cron/monitor-friendly); weekly deep review Mondays per P39 cadence.

## 4. First Execution Output (MEASURED, 2026-08-26T01:47Z)

```
$ chmod +x ops/scripts/p40-field-growth-check.sh && ops/scripts/p40-field-growth-check.sh; echo exit=$?
p40-field-growth index=wazuh-archives-4.x-2026.08.26 leaf_fields=1604 limit=2000 verdict=WARN growth_per_day=n/a
branches: data:1537 rule:27 GeoLocation:8 agent:6 predecoder:6 cluster:4
log: /opt/mct-security-stack/ops/reports/p40-field-growth.log state: /opt/mct-security-stack/ops/evidence/p40-field-growth-state.tsv
exit=1
```

First run is already **WARN**: 1604 > soft 1400 at H+1.8h (growth_per_day n/a — first
state row). Expected per phase40-07 trajectory analysis; NOT a fault, but it means the
guardrail's watch period starts immediately.

## 5. Alert Path

Each run appends to `ops/reports/p40-field-growth.log`; WARN/CRIT additionally flagged
into the open-work ledger sync (phase40-00 §5). CRIT triggers the containment decision
below within one business day.

## 6. Containment Action on CRIT/Sustained Growth

Per phase40-12 §3: delete-template rollback is NOT the containment for growth (it only
affects future indices); the correct response is sensor-side EVE event-type filtering /
compact-stats selective forwarding to shrink `data.*` demand — designed in phase40-12,
operator-approved before any change.

## 7. Verdict

**APPLIED — COMPLETE.** Script on disk, executable, executed with embedded output;
thresholds live; alert path defined.
