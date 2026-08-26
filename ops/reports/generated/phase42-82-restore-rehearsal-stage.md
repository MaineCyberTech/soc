# Phase 42 Restore-Rehearsal Staging Progress — DR-STAGE-42-01

**Report ID:** phase42-82-restore-rehearsal-stage
**Phase:** 42
**Title:** Rehearsal Staging Within Automation Limits — Validation Battery Extended V1–V7 + V8 (P41) → **V9 Bundle Staged** (v1.3.1 Asset-Verify Step, Watchdog-Presence Check, Compact-Stats Timer Reaffirm); Stage Sequence UNCHANGED From Plan v3; Execution NO-GO Standing
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:54:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-82-restore-rehearsal-stage.md`

---

## 1. Scope and hard limit

This report stages rehearsal readiness only. Per the approval-gated operations
rules (AGENTS.md), executing a full-system restore rehearsal requires an
approved external target plus recorded operator sign-off. Nothing in this arc
executed, simulated, or dry-ran a restore against production state beyond the
already-certified spot-check pattern.

## 2. Validation battery — V9 additions staged

Battery lineage: V1–V7 (RESTORE-PLAN-40-02 → plan v3) + V8 lane-integrity
bundle (phase41-33 R2). This phase stages **V9**, motivated by what P41/P42
proved can silently rot while a restore still "looks green":

| Item | Check definition (to execute only at an authorized rehearsal) | Failure mode it pins | Lineage |
|---|---|---|---|
| **V9a — v1.3.1 release-asset custody verify** | On-box `ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz` sha256 recomputed = MANIFEST record `4e6c3712…ebf596`; tag `v1.3.1` resolvable on origin | Release asset restored-but-stale / corrupted mid-flight; custody chain breaks exactly when needed | CUSTODY-41-01 standard; phase42-79/-80 |
| **V9b — delivery-monitor watchdog presence** | `p41-monitor-watchdog.sh` present in target crontab at offset minutes 3,18,33,48 AND alert sink `ops/reports/p41-monitor-watchdog.log` exists post-restore | Monitoring layer absent after restore → silent future failures look like none | watchdog live phase41-39/-43; certified phase42-59 |
| **V9c — compact-stats timer reaffirm (extends V8c)** | Sensor-side `suricata-compact-stats.timer` active with ≤60s cadence observed (`systemctl list-timers`) AND indexed `data.event_type:stats_compact` growth visible in a fresh archive index | Field-growth containment silently un-restored → guardrail re-approach undetected | G41-14 posture; sensor timer verified live this session (last tick 09:45:02Z, next +6s) |

V9 is defined, versioned, and cited from the plan-of-record lineage; no battery
item has ever been executed against a full-system target (spot-checks are
explicitly out of scope per phase42-64 §1).

## 3. Stage sequence — unchanged

The execution sequence remains exactly plan v3's staging order (phase41-33):
target bring-up → snapshot restore → services up → V1…V7 functional gates →
V8a/b/c lane-integrity gates → V9a/b/c custody-and-monitoring gates → evidence
bundle → teardown. No stage was reordered, added to execution, or executed.
The only delta this phase is the V9 appendix above, which lengthens the
post-restore gate list, not the restore path.

## 4. Execution posture

**NO-GO standing**, inherited from phase41-34 and re-affirmed by the scoreboard
(phase42-81): red gates G-D (signature) and G-E (target approval) are both
owner-held. When they flip, GO requires zero further design or scripting work —
the complete gate list through V9c is already specified and its pass criteria
are mechanically checkable.
