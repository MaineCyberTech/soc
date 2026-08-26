# Phase 39 Restore Rehearsal Plan — Staged Go/No-Go

**Report ID:** phase39-84-restore-rehearsal-plan
**Phase:** 39
**Title:** PLAN-DR-39-01 — Seven-Stage Rehearsal: Approvals → Archive Deploy → Config/Secrets → Snapshot Restore Order → Validation Battery (Canary sid 2027967) → RTO/RPO Measurement → Teardown; Execution NO-GO Until Stage0 Complete
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** NO-GO (execution blocked pending Stage0)
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-84-restore-rehearsal-plan.md`

---

## 0. Stage0 — Approvals + target provisioned (GATE)

Owner gates enumerated:
1. RESTORE-CRIT-39-01 checklist fully ticked (target ≥8c/32GB/300GB SSD, isolated).
2. RTODRF-39-01 sign-offs logged (or rehearsal explicitly runs to DEFINE RTO).
3. Rebuilt-labeled asset acceptance per phase39-70 owner action item.
4. Rollback authorization: pre-stage clone/snapshot capability proven on target.
**NO-GO stands until all four are true.**

## 1. Stage1 — Release-asset deploy

Copy `ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz` (sha256 65f794a7…,
labeled REBUILT) to target; extract preserving `v1.3.0/` prefix;
`docker compose` up the stack set from `compose/*.yml`. Record T0 at extraction
start. **Rollback:** reclone target, restart stage.

## 2. Stage2 — Configs/secrets injection procedure

Populate `.env` from `.env.example`; place `creds.env` at the documented path
(git-ignored); mount manager certs/indexer certs from extracted `config/`
directory tree; verify file ownership matches container uids. Record T1 at first
healthy container. **Rollback:** wipe injected secrets, reclone.

## 3. Stage3 — Snapshot restore order

From fs repo (`wazuh-backup`, latest SUCCESS snapshot):
1. Security indices (`.opendistro_security`, `.kibana_1`) — platform auth first.
2. Users/system states (`wazuh-states-inventory-*`).
3. Alerts sample (one recent daily index, e.g. 2026.08.25, 34mb class).
4. Archives sample (2026.08.15 candidate, 932mb class — doubles as restore-size proof).
Restore with replicas:0 during bootstrap. Record T2 per index batch.
**Rollback:** delete restored indices, re-run order subset.

## 4. Stage4 — Validation battery

| # | Check | Pass criterion |
|---|---|---|
| V1 | Agent enrollment test container | new agent registers + goes active against restored manager |
| V2 | Ingest canary | synthetic event end-to-end with sid lineage matching canary method (P35 baseline; sid 2027967 reference chain) |
| V3 | Shuffle auth + workflow exec | login OK + one workflow execution reaches completion |
| V4 | IRIS delivery probe | reuse P36-era probe path; delivery acknowledged |
Record T3 at battery completion. **Rollback:** halt integrations, reclone.

## 5. Stage5 — RTO/RPO measurement protocol

Timestamps captured at every boundary: T0 extraction start · T1 stack healthy ·
T2 each restore batch · T3 validation complete.
- Measured RTO(full-stack) = T3 − T0 (first-ever real measurement).
- Measured RPO per tier = newest-data-time(restored) − snapshot start_time used.
Results land in a successor report and supersede RTODRF-39-01 proposals where measured.

## 6. Stage6 — Teardown + cleanup

compose down -v → remove extracted tree/images → delete target clone lineage →
verify zero residual objects in shared resources → archive logs of T0–T3 into
ops/evidence/p39-dr-rehearsal/.

## 7. Standing status

**Execution remains NO-GO until Stage0 completes.** No stage may run on the
production host under any circumstance (RESTORE-CRIT-39-01 §6 disqualification).
