# Phase 39 RTO/RPO Inventory — Measured Evidence Only

**Report ID:** phase39-81-rto-rpo-inventory
**Phase:** 39
**Title:** RTOINV-39-01 — Backup Frequencies Measured From Snapshot Start_Times (fs ~5–6/day, s3 daily 20:47Z); Bundle Cadence Daily 04:00; P27 Restore Drill PASS (3 Indices, Seconds-Scale); NO-INVENTED-OBJECTIVES
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-81-rto-rpo-inventory.md`

---

## 1. NO-INVENTED-OBJECTIVES statement

This inventory records **measured facts only**. No RTO or RPO target is asserted,
derived, or implied anywhere in this report. Target-setting is deferred to
RTODRF-39-01 as an explicit PROPOSED-BUSINESS-DECISION.

## 2. Backup frequencies — measured from snapshot cadence

**fs repo `wazuh-backup`: 42 snapshots.** Distinct daily start_times observed:
00:17, 03:30, 05:17, 10:17, 15:17, 20:17 → **~5–6 snapshots/day**, irregular but
dense; worst measured gap between consecutive snapshot slots ≈ **5h**
(20:17 → next-day 00:17 is 4h; 15:17→20:17 is 5h).

**s3 repo `do-spaces`: 85 snapshots**, daily at **20:47Z** through
`s3-snap-20260822-2047` in the visible tail → **daily off-box cadence**;
worst gap ≈ **24h**.

## 3. Bundle cadence

`ops/backups/phase2-config-YYYYMMDD-0400*.tar.gz` present for Aug-10→Aug-25
including today's `phase2-config-20260825-040001.tar.gz` → **daily config-bundle
cadence at 04:00 local**, plus ad-hoc manual bundles on Aug-10 (12 files).

## 4. Restore proofs ever executed

- P27 multi-index restore drill: **PASS** — 3 states indices restored to
  `p27-restore-*`, doc counts 114/447/2248 snapshot-consistent, cross-index query
  returned 2809 hits (`canonical/phases/phase27/phase27-27-rto-rpo-update.md:12`).
  Duration class recorded there: **seconds-scale** for states indices.
- P39 spot-check RESTORE-CHK-39-01: 1mb monitoring index restored GREEN and
  deleted clean (this phase).
- Full-cluster restore rehearsal: **never executed** (NO-GO pending adequate target).

## 5. Data classes present

| Class | Location | Backup mechanism |
|---|---|---|
| Alerts | wazuh-alerts-4.x-* | fs + s3 snapshot repos |
| Archives | wazuh-archives-4.x-* | fs + s3 repos; ISM 14d retention |
| States/inventory | wazuh-states-inventory-* | both repos |
| Configs | /var/ossec/etc, compose/, .env templates | daily tar bundles + git |
| Workflows | Shuffle exports (p37/p38/p39-workflow-export) | git-tracked exports |
| Release binaries | ops/releases/v1.3.0/*.tar.gz | **NONE (gitignored *.tar.gz)** |

## 6. Dependencies inventory (containers)

Manager plane: `multi-node-wazuh.master-1`, `multi-node-wazuh.worker-1`,
3× indexers, `multi-node-wazuh.dashboard-1`. Integrations: shuffle-frontend/
backend/workers/healthcheck, wazuh-cloudflared, mct-security-stack-opencanary-1,
flow-relay, security-onion, tenzir-node.

## 7. Measured durations cited

Only the P27 seconds-scale restore of small states indices exists as a duration
measurement. No full-stack rebuild duration has ever been measured.
