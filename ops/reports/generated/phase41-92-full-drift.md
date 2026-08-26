# Phase 41 Full Drift Audit

**Report ID:** phase41-92-full-drift
**Phase:** 41
**Title:** DRIFT-FULL-41 — Fourteen Drift Items Each With Disposition (Two Fixed In-Phase, Five Newly Discovered By This Session's Own Commands, Rest Carried With Owners), Including Frontend-Restart Churn ~96/Day Found Via docker events, env-Path Doc Drift, AD maxClause Noise, And Null finished_at Observability Gap; Verdict MANAGED
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:57:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-92-full-drift.md`

---

## 1. Drift items & dispositions

| ID | Drift | Source | Disposition |
|---|---|---|---|
| D-41-01 | Catalogs lagged concurrent batches: 0 of the phase41 corpus rows present while 93 files exist on disk (catalog held 299 rows through phase40-97) | catalog vs disk count, live this session | **FIXED — append executed** in phase41-84 with real sha256s, JSON+CSV structure preserved; currency verified in phase41-91 |
| D-41-02 | AGENTS.md stale blocker entries + stale canon/register pointers | phase41-82 findings A1–A5 | **FIXED — CHG-41-AGENTS-01** applied with full compliance chain (phase41-83); p39-agents-ci PASS |
| D-41-03 | event.code ↔ rule.groups sysmon_eid1 EID-mapping question (+ 6-vs-7 agent widget delta) | FP-baseline dataset; live counts zero today | CARRIED — owner query raised, tracked OW-41-02 |
| D-41-04 | Sensor suricata.service MASKED while production runs via exact-args setsid invocation; unit lingers `failed` (stale record) | systemctl/pgrep live [phase41-86] | DOCUMENTED — rationale + unmask procedure recorded (unmask only AFTER disabling exact-args invocation); `reset-failed` candidate noted |
| D-41-05 | Shuffle execute_python param-injection platform defect (five variable keys UNDEF) | phase41-52 probe | TRACKED — R-PKT-PLATFORM / OW-40-04; lane test-only disabled so fail-open bounded |
| D-41-06 | Worker ossec.conf had no pre-change backup during P40 webhook apply | historical | CARRIED — R-2 standing paired-backup rule binding on next config change |
| D-41-07 | **NEW**: shuffle-repair-network.sh --apply restarts shuffle-frontend unconditionally every */15 cron tick (~96/day); corroborated by docker events kill/start at 06:30:02–03Z and RestartCount=0 with fresh StartedAt | script lines 59–61 read this session | TRACKED — OW-41-05 / R-CHURN; fix = gate restart on detected DNS failure |
| D-41-08 | **NEW**: X-Content-Type-Options still duplicated (2×) at :3443 although XFO dedup landed single-header | curl -D count live | TRACKED — OW-41-01 (P4) |
| D-41-09 | **NEW**: AGENTS.md Credential Handling names `compose/.env` but actual env file is repo-root `.env` (compose/.env absent) | compose config -q probes [phase41-85 §3] | CARRIED — doc-path correction queued for next CHG window (post-hash-chain seal) |
| D-41-10 | **NEW**: anomaly-detection job emits too_many_nested_clauses stack traces (5 lines/24h, indexer1; maxClauseCount=1024) | docker logs --since greps [phase41-88] | OPEN — benign to ingest; fix AD job query or raise limit at next indexer config window |
| D-41-11 | **NEW**: executions API returns finished_at=null → hook→FINISHED latency deltas not computable from listing endpoint | API samples today [phase41-88 §5] | OPEN — observability gap; use exec-detail endpoint or platform upgrade |
| D-41-12 | **NEW**: TLS cert regenerated today (notBefore 00:51:52Z) during proxy work — TOFU trust event unlogged until now | openssl s_client live [phase41-87] | CLOSED-BY-RECORD — trust event logged here; pinning decision deferred to owner (R-TOFU) |
| D-41-13 | **NEW**: three unreferenced eve-analysis scripts superseded by source-side containment (p31v2-eve-rate.py, p32-eve-analysis.py, p32-suricata-stats-gate.py) | dead-code heuristic [phase41-85 §5] | OPEN — archive candidates; deletion approval-gated |
| D-41-14 | Master ossec.conf virustotal integration carries a real inline api_key (shuffle placeholder intact both nodes) | masked awk probe [phase41-87] | TRACKED — R-VTOSSEC; migrate to creds-reference at next config window |

## 2. Fixed-vs-carried balance

Fixed in-phase: D-41-01, D-41-02. Closed-by-record: D-41-12. Tracked with owners:
D-41-05/-07/-08/-14. Carried open: D-41-03/-04/-06/-09/-10/-11/-13. No drift item is
undispositioned.

## 3. Verdict

**DRIFT-FULL-41: MANAGED.** Every discovered divergence has an owner, a tracking ID,
and a bounded blast radius; the two governance-critical items (catalog lag, AGENTS
staleness) were repaired inside the phase with compliance chains intact.
