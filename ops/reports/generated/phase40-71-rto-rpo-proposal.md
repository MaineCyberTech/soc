# Phase 40 RTO/RPO Proposal — Final Per-Service Table (Business Decision Required)

**Report ID:** phase40-71-rto-rpo-proposal
**Phase:** 40
**Title:** RTODRF-40-01 — PROPOSED-BUSINESS-DECISION Targets per Service/Data Class: P39 Values Retained Where No New Evidence Adjusts Them; s3 Cadence Correction Strengthens Archives Basis; New Reports-Corpus Row Added; Every Row Labeled PROPOSED, None Achieved or Binding
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:45:00Z
**Classification:** INTERNAL
**Status:** DRAFT (PROPOSED-BUSINESS-DECISION — supersedes phase39-82 table for tracking; nothing binding until DEC-40-01 signed)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-71-rto-rpo-proposal.md`

---

## 1. Status discipline

Every value in §2 is a **proposal** grounded in the fresh evidence inventory
(RTOEV-40-01, phase40-70). No row is achieved, committed, or citable as a
commitment until the owner records adopt/modify/reject decisions in DEC-40-01
(phase40-72). P39 numbers (phase39-82) are retained verbatim unless new
evidence adjusts them; adjustments are flagged inline.

## 2. Proposal table

Legend — **measured?**: what scale of restore evidence exists. **target-only?**:
value is meaningful only once an adequate isolated external target exists
(RESTORE-CRIT-39-01).

| Class | RPO proposed | Basis (measured) | RTO proposed | Basis (measured/estimate) | Measured? | Target-only? |
|---|---|---|---|---|---|---|
| Wazuh manager cluster (config + shared configs) | ≤24h | git-tracked config baseline + daily compose/config commits observed 17:42–00:11Z window | ≤2h | small config surface; redeploy from release asset is PLAN Stage1 path — never timed | Cadence yes; restore NO | Partially (manager itself needs target) |
| Indexer/OpenSearch — alerts tier | ≤1h | fs snapshots ~5–6/day ⇒ worst gap ≈5h ⇒ **1h NOT currently met by cadence**; requires schedule increase or replication if adopted | ≤4h | single-index mechanics proven (<10s spot-check #2); full alert-index volume restore untested | Spot-check only | YES |
| Indexer/OpenSearch — archives tier | ≤24h | **ADJUSTED BASIS:** s3 measured at fixed 5/day (5h gaps), not "daily" as P39 assumed ⇒ ≤24h comfortably met today | ≤8h | largest class (932mb index) never restored; ISM retention bounds exposure window | Spot-check only (1mb class) | YES |
| Shuffle (workflows, datastore, webhook blocks) | ≤24h | workflow exports + integration blocks in git-tracked config baseline; hooks doc registration documented as rebuild step | ≤2h | compose redeploy + import steps exercised piecewise today (workflow import, hook registration), never timed end-to-end | Piecewise; timing NO | YES |
| IRIS (cases/alerts DB) | ≤24h | daily 04:30 sql.gz dumps present since 08-12 (`ops/backups/`) | ≤2h | engineering estimate: compose up + sql load-back — **load-back NEVER rehearsed** (phase40-70 §7.4) | Cadence yes; restore NO | YES |
| Dashboards (saved objects) | ≤24h | ndjson artifacts inventoried + import proven working (phase40-61/62); re-import is a documented plan step | ≤2h | import executed successfully today but duration not captured; folded into stack RTO | Import works; timing NO | YES |
| Configs/secrets (env, creds.env, certs) | n/a (static, versioned) | secrets deliberately excluded from backups; injection procedure defined (Stage2) | (folded into ≤2h config tier) | **injection time under pressure UNMEASURED** (explicit unmeasured step) | Procedure only | YES |
| Reports corpus (this directory) | ≤24h | git push cadence — multiple pushes observed 08-25→08-26 (17:42Z, 21:44Z, 00:11Z); NOTE: working tree currently carries uncommitted modifications, so ≤24h holds only with push discipline | ≤1h | clone + CI regeneration estimate; clone of repo never timed on clean target | Push cadence yes; RTO NO | NO (any host with network) |
| Endpoints re-enrollment (fleet) | n/a (agent-side buffering; loss = local queue contents) | agents queue while disconnected; queue behavior characterized per-agent in prior phases | UNDEFINED until measured | fleet-scale re-registration time unknown; single-agent reconnects observed incidentally only | Single-agent anecdotes only | YES |
| Client ops deliverables (scorecards/billing/monthly) | follows source tiers | derived data regenerated from restored indices/repo — no independent backup needed | ≤4h after sources restored (PROPOSED-DERIVED) | generation scripts run routinely (measured operationally across phases) post-restore; combined time never timed on restored data | Generation routine; on-restored-data NO | YES |
| Full cluster (all above together) | n/a | — | UNDEFINED; aspirational draft ≤24h (unchanged from P39) | full rehearsal NEVER executed; no adequate target exists | NO — zero rehearsals | YES |

## 3. Changes vs phase39-82

1. **Archives basis corrected:** s3 cadence measured fresh at 5/day (worst gap
   ≈5h), replacing the erroneous "daily" characterization. Proposed value kept
   at ≤24h (conservative business proposal); the honest current state is
   stronger than the proposal requires.
2. **Reports-corpus row added** (RPO ≤24h via git push; RTO ≤1h clone+CI).
3. Alerts-tier honesty retained: proposed ≤1h RPO is **not met by current
   cadence** — adoption implies funding a cadence change or accepting ≈5h.
4. All other values carried unchanged from P39.

## 4. Non-goals

No claim that any proposed RTO has been demonstrated end-to-end. The only
measured restore durations remain two small-index spot-checks (P39 minutes-class;
P40 <10 s, phase40-57 §5). Full-stack measurement awaits Stage0–Stage5 of the
restore plan (RESTORE-PLAN-40-02).
