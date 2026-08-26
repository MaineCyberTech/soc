# Phase 38-35: Incomplete Work Scan

**Title:** Phase 38-35: Incomplete Work Scan
**Report ID:** phase38-35-incomplete-work-scan
**Phase:** 38
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-35-incomplete-work-scan.md`
**Retention Class:** LONG
**Author:** opencode (ox-alpha)

---

## 1. Purpose

Trace every P0–P3 action, roadmap item, and blocker declared across phase finals into later evidence, and classify each as OPEN / STALLED / REPEATEDLY-DEFERRED / DROPPED / PARTIAL. Trace endpoints are the latest reports or live state (2026-08-25).

---

## 2. Traced Items

### INC-01: Shuffle exposure hardening — REPEATEDLY-DEFERRED (P0)

| Field | Value |
|---|---|
| Origin | Exposure documented `phase37-04-shuffle-listener.md:74` ("No firewall on 3001 \| HIGH \| Active"); plan `phase37-06-shuffle-exposure-plan.md` |
| Chain | Apply blocked on approval (`phase37-07-shuffle-exposure-apply.md:5,41` "PENDING… iptables rules applied ⏸") → P37 roadmap #1 "Harden Shuffle" (`phase37-81-final.md:133`) → P38 plan re-written again (`generated/phase38-73-shuffle-hardening.md:3` "PLAN-DEFERRED") → backlog BCK-38-001 OPEN (`generated/phase38-90-backlog.md:59`) |
| Live truth | `ss -tlnp`: LISTEN 0.0.0.0:3001; HTTP 200; no TLS. Unchanged since first documented. |
| Classification | REPEATEDLY-DEFERRED — three consecutive phases produced plans without a single applied rule |
| Blocker | Operator approval (never recorded; see phase38-34 MISS-08) |

### INC-02: Packet workflow creation — STALLED at design (P1)

| Field | Value |
|---|---|
| Origin | P37 packet series 17–31 (decision → create → normalize → validate → …) |
| State | Creation never executed: `phase37-81-final.md:35-40` "Implementation: DEFERRED… Design only"; P38 repeated the pattern (`generated/phase38-75-packet-workflow.md`, `phase38-76-packet-workflow-proof.md` both require creation first) |
| Classification | STALLED — two full design passes, zero runtime artifact |

### INC-03: Wazuh→Shuffle integration — OPEN since P36 (P1)

| Field | Value |
|---|---|
| Origin | Blocker report with 5-step resolution path (`phase36-17-shuffle-wazuh-integration-blocker.md` §Resolution path) |
| Chain | P36 final rec #2 "Configure Wazuh→Shuffle webhook via Shuffle UI" (`phase36-75-final-report.md:72`) → P37 backlog #3 (`phase37-74-backlog.md` P2 row) → P37 roadmap #4 (`phase37-81-final.md:136`) → BCK-38-005 lineage in master roadmap item 7 |
| Live truth | No ossec.conf integration configured; 0 real routing executions |
| Classification | OPEN — resolution path fully specified and untouched for the entire window |

### INC-04: Credential rotations — PARTIAL (P1)

| Field | Value |
|---|---|
| Done | Admin password rotated server-side with pre/post proof tables (`phase37-03-shuffle-password.md`: old credential rejected pre+post, new verified) |
| Open | (a) Operator receipt/verification all ⏸ (`phase37-03` §Operator Rotation Status); (b) bearer-token rotation still queued (master roadmap item 5, `generated/phase38-00-master.md:169`); (c) original operator advice from P36 ("Change Shuffle password after first login", `phase36-75-final-report.md:71`) superseded but receipt loop unclosed |
| Classification | PARTIAL |

### INC-05: Agent recovery 013/015 — STALLED (P2)

| Field | Value |
|---|---|
| Origin | Recovery program P36: `phase36-37-endpoint-013-recovery.md`, `phase36-38-endpoint-015-recovery.md`, strategy `phase36-41`, summaries `phase36-43/44` |
| Chain | P37 status-only follow-ups (`phase37-51-agent013-status.md`, `phase37-52-agent015-status.md`) → P37 backlog demotes recovery to P3 row #6 (`phase37-74-backlog.md`) |
| Live truth | Both agents DISCONNECTED (live state 2026-08-25); posture unchanged: "waiting", no automated recovery (`phase37-81-final.md:79-83`) |
| Classification | STALLED — monitoring continued, recovery actions did not |

### INC-06: ISM deletion wave observation — SCHEDULED, NOT OBSERVED (P2)

| Field | Value |
|---|---|
| Origin | Attachment fix + forecast `phase36-75-final-report.md:12-16`; observation requirement `phase37-81-final.md:63` "Observation required on 08-29" |
| State | Pre-wave verification only (`generated/phase38-79-retention-verification.md`: zero deletions; ISM explain empty — mechanics uncertain) |
| Classification | OPEN by design until 2026-08-29; risk flagged because relief is budgeted in disk forecasts while execution mechanism is unverified |

### INC-07: Field error resolution — OPEN after partial mitigation (P0)

| Field | Value |
|---|---|
| Origin | Baseline/measurement/fix P36 (`phase36-29/30/32`) |
| Applied | decoder_order_size 256→512 + restart (PID recorded, `phase36-75-final-report.md:28`) |
| Failed outcome | ~100/min persists (`phase37-38-field-postlogs.md`) |
| Staged-not-applied | Option (a) stats minimization attempted then set aside (`phase37-39-stats-minimization.md`, test in `-40`); option (b) 1024 contingency planned, NOT applied (`phase37-41-field-limit-plan.md:13`, `phase37-42-field-limit-apply.md:3` "NOT YET APPLIED"); decision record `phase37-43-field-resolution.md:3` "RESOLUTION PENDING" |
| Classification | OPEN — one mitigation applied and proven insufficient; successor mitigations designed only |

### INC-08: Production alert routing enablement — REPEATEDLY-DEFERRED (P1)

| Field | Value |
|---|---|
| Chain | P34 git dca1691 "production routing still deferred" → P35 git cbcca53 "Shuffle routing deferred (UI-gated)" → `phase37-32-routing-decision.md:9` DEFERRED (reasons incl. "No owner approval") → carried as roadmap item again (`final-phase37-operator-report-20260825-1943Z.md:133` context) → master roadmap item 7 |
| Live truth | 796 executions, all healthchecks; 0 production routes |
| Classification | REPEATEDLY-DEFERRED across ≥4 phases |

### INC-09: Report migration apply — DEFERRED post-dry-run (P2/P3 docs track)

| Field | Value |
|---|---|
| Chain | Plan `generated/phase38-59-migration-plan.md` → dry-run PASSED `generated/phase38-68-migration-dryrun.md` → apply DEFERRED pending operator approval `generated/phase38-69-migration-apply.md:5,18-20`; verify step `phase38-70` therefore unexecuted |
| Classification | STALLED at approval gate |

### INC-10: Corpus hygiene batch — OPEN (P3)

| Field | Value |
|---|---|
| Items | Delete 8 empty stubs (master roadmap #1); mark 60 superseded files (`generated/phase38-00-master.md:166` citing phase38-06); consolidate 20 backup-dr-audit files (#9) and 7 alert-volume files (#10); reconcile phase38-03's "1,877 canonical" vs inventory totals |
| State | None executed as of 2026-08-25 (stubs still 0 bytes; duplicates still present per `generated/phase38-05-report-hash-duplicates.md` groups D1–D3) |
| Classification | OPEN |

---

## 3. Summary

| ID | Item | Class | Latest evidence |
|---|---|---|---|
| INC-01 | Shuffle hardening | REPEATEDLY-DEFERRED | live ss 0.0.0.0:3001 |
| INC-02 | Packet workflow | STALLED (design ×2) | phase38-75/76 headers |
| INC-03 | Wazuh→Shuffle integration | OPEN | phase36-17 unchanged |
| INC-04 | Credential rotation | PARTIAL | phase37-03 ⏸ rows |
| INC-05 | Agent 013/015 recovery | STALLED | live fleet state |
| INC-06 | ISM wave observation | SCHEDULED | phase38-79 |
| INC-07 | Field error resolution | OPEN (512 insufficient) | live ~100/min |
| INC-08 | Routing enablement | REPEATEDLY-DEFERRED | phase37-32 |
| INC-09 | Migration apply | STALLED (approval) | phase38-69 |
| INC-10 | Corpus hygiene | OPEN | phase38-05 stubs/dups |

Pattern worth naming: **approval-gated items dominate** — of 10 traced items, 4 (INC-01, 08, 09 + MISS-08 approvals) sit behind an operator gate for which no approval artifact exists anywhere on disk.
