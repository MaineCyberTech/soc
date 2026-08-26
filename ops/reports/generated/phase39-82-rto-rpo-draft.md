# Phase 39 RTO/RPO Draft — Proposed Targets by Data Class (Business Decision Required)

**Report ID:** phase39-82-rto-rpo-draft
**Phase:** 39
**Title:** RTODRF-39-01 — PROPOSED-BUSINESS-DECISION Targets: Alerts RPO≤1h/RTO≤4h; Archives RPO≤24h/RTO≤8h; Config/Workflows RPO≤24h/RTO≤2h; Full-Cluster RTO Undefined Until Rehearsal; Owner Sign-off Required
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** DRAFT (PROPOSED-BUSINESS-DECISION — no target is binding until signed)
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (owner sign-off required)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-82-rto-rpo-draft.md`

---

## 1. Status discipline

Every value below is a **proposal grounded in measured cadence**
(RTOINV-39-01). None is achieved or committed until the owner signs the §3 line
items and a rehearsal measures actuals.

## 2. Proposed targets vs measured basis

| Tier | Proposed RPO | Measured cadence supporting it | Proposed RTO | Basis / gap |
|---|---|---|---|---|
| Alerts | ≤1h | fs snapshots ~5–6/day → worst gap ~5h ⇒ **1h NOT currently met**; would need snapshot frequency increase or continuous replication | ≤4h | restore mechanics proven at small scale (P27, P39); full alert-index volume untested |
| Archives | ≤24h | s3 daily 20:47Z + fs multi-daily ⇒ met today for daily-loss tolerance | ≤8h | single-index restore proven (932mb class pending test); ISM window bounds exposure |
| Config/workflows | ≤24h | daily 04:00 bundles + git-tracked exports ⇒ met | ≤2h | configs are small; compose redeploy from v1.3.0 archive is the path (PLAN-DR-39-01 Stage1) |
| Full cluster | n/a | — | **UNDEFINED until rehearsal; aspirational draft ≤24h** | never rehearsed; current LXC host lacks capacity (RESTORE-CRIT-39-01) |

Measured-vs-target column discipline: where measured cadence fails the proposal
(alerts RPO), the table says so explicitly rather than quietly rounding.

## 3. Owner sign-off required (line items)

- [ ] Approve/reject alerts-tier RPO ≤1h AND fund the cadence change it requires (or accept ≤5h as honest current state).
- [ ] Approve archives-tier RPO ≤24h / RTO ≤8h.
- [ ] Approve config/workflows RPO ≤24h / RTO ≤2h.
- [ ] Acknowledge full-cluster RTO is UNDEFINED and authorize Stage0 target provisioning to begin measurement.
- [ ] Accept rebuilt-labeled release asset as rehearsal input (phase39-70 PARTIAL item).

## 4. Non-goals

No claim is made that any proposed RTO has been demonstrated. The only measured
restore durations remain P27's seconds-scale states-index drill and this phase's
1mb spot-check.
