# Phase 41 Restore Rehearsal Plan — Refinements Only (No Execution)

**Report ID:** phase41-33-restore-rehearsal-plan
**Phase:** 41
**Title:** PLAN-DR-41-01 — Plan v3 Refinements To RESTORE-PLAN-40-02: Published-Original Promoted To PRIMARY Artifact (Rebuilt-First Ordering Retired), Post-Restore Validation Battery Extended With V8 Bundle (Hooks-Doc Registration + TLS-Proxy Health + Compact-Stats Timer); Measurement Protocol UNCHANGED; Zero Stages Executed
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:59:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY (no execution; NO-GO maintained by GATE-DR series)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-33-restore-rehearsal-plan.md`

---

## 1. Relationship to prior plans

Refines **RESTORE-PLAN-40-02** (phase40-73), which refines PLAN-DR-39-01
(phase39-84). Nothing not listed below changes. No stage has executed — the
plan grows sharper only so the future owner session is shorter.

## 2. Refinement register (v3 deltas)

| # | Delta | Content | Evidence |
|---|-------|---------|----------|
| R1 | **Artifact ordering swapped: published-original is PRIMARY.** Stage1 now specifies `v1.3.0-published-original.tar.gz` sha256 `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c` as the rehearsal input, verified byte-exact against the published identity and stored in `ops/releases/v1.3.0/`. The rebuilt-labeled variant (`65f794a7…`) drops from primary to verified-fallback, used only if the original is found corrupt at extraction (hash re-check at copy time stays mandatory either way) | Removes the P38/P39/P40 caveat that the drill would run on a non-published byte stream; the drill now exercises exactly what clients received | custody upgrade phase41-32 §1; prior rebuilt-first ordering phase40-73 §3 Stage1; published-hash lineage phase30-20 |
| R2 | **Validation battery extended with V8 bundle** (appended after V7):  **V8a — hooks-doc registration recheck:** `hooks/_doc/<trigger-id>` present with correct start/owner/org_id before any V3 execution counting (extends D3/V5 from a point-check to an explicit gate item).  **V8b — TLS proxy health:** `shuffle-tls-proxy` up with cert mounts; :3443 answers TLS on the target binding; plaintext exposure absent.  **V8c — compact-stats timer check:** if compact-stats/selective-forwarding is adopted at rehearsal time (BCK-40-001 posture), its schedule/timer must exist post-restore with first tick observed; if not yet adopted, record skip-with-note rather than silent omission | The three lanes most able to look "restored" while being silently broken are each pinned to an explicit pass/fail line | hooks defect+fix chain phase40-33→38; TLS implementation/certification phase40-27..32; compact-stats design phase40-12 §3 + backlog BCK-40-001 (phase40-91) |
| R3 | **Measurement protocol UNCHANGED — deliberately frozen.** T0 extraction start · T1 stack healthy · T2 per restore batch · T3 validation complete; measured RTO = T3−T0; measured RPO per tier = newest-data-time − snapshot start_time. Frozen so P39/P40 proposals stay comparable with whatever the drill measures | Any temptation to redefine timing mid-drill is pre-refused | protocol phase39-84 §5; reaffirmed phase40-73 §3 Stage5 |

## 3. Updated validation battery summary (post-V8)

V1 agent enrollment · V2 ingest canary · V3 Shuffle auth+exec · V4 IRIS
delivery probe · V5 hooks-doc registration (now subsumed by V8a gate) · V6
dashboard re-import · V7 delivery-monitor cron + manual probe · **V8 lane-
integrity bundle: V8a hooks-doc · V8b TLS proxy · V8c compact-stats timer.**

## 4. Standing status

**No execution occurred today and none is authorized.** GATE-DR posture remains
NO-GO pending target + objectives + approvals (phase41-34). The plan's
completeness is the point: with R1–R3 applied, an adequate target plus one
owner sitting converts NO-GO to GO with zero further design work.
