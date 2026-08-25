# Phase 38 Monthly Operations Cycle Record

**Report ID:** phase38-93-monthly
**Phase:** 38
**Title:** Phase 38 Monthly Operations Cycle Record
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-93-monthly.md`

**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-93-monthly.md`
**Retention Class:** LONG

| Field | Value |
|-------|-------|
| **Report ID** | phase38-93 |
| **Generated** | 2026-08-25 21:30 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | COMPLETE |
| **Cycle covered** | August operating month, closing snapshot 2026-08-25T21:30Z |
| **Supersedes** | Draft written 2026-08-25T20:11Z |

---

## 1. Endpoint Sweep Results

Fleet verified live via Wazuh manager API (`agent_control` binary absent in container — API is the sanctioned interface; runbook updated accordingly).

| Agent | State | Notes |
|-------|-------|-------|
| 000 (manager) + 006, 007, 011, 012, 014, 016 | ACTIVE | Uniform v4.14.7; 016 carries Suricata sensor duty |
| 013 (SAMSUNG) | OFFLINE ~15h | Last keepalive 06:20Z; recovery stalled pending site access |
| 015 (Julians-Air) | FLAPPING | Reconnected 20:11:20Z today; disconnected again by 21:06Z query — treat as intermittent macOS client (sleep/lid class), not restored |
| 008 | RETIRED | Absent from roster; confirmed consistent |

Sweep verdict: **8 of 9 registered endpoints active at design intent**, with two stability caveats (013 hard-down, 015 unstable). Billing eligibility per phase38-80 §4.

## 2. Packet Pipeline Health

- **Capture:** Suricata EVE telemetry flows continuously from agent 016 into archives tier; alert-grade path verified by canonical count `_count?q=suricata` = **433** across `wazuh-alerts-*` (all shards green) — matches the phase38-24 proof exactly.
- **Detection:** canary E2E (sid 2027967) stands PROVEN from P35, carried forward; independently corroborated this cycle by real honeypot payloads observed transiting SOAR automation (53× level-12, 11× level-10 events).
- **Known defect (fix applied):** indexer-side field-limit rejections on the ARCHIVES tier (~147–150/min, ~14.1k/day) caused by index-template field budget on Filebeat docs. Root cause corrected today via composable template `wazuh-archives-fieldlimit` (limit 2000 + carried ISM setting, priority 320); PUT acknowledged and GET verified; affects new daily indices only. Alert-tier pipeline unaffected throughout. Proof expected with tomorrow's index.

## 3. Workflow Audit Summary

Per-workflow execution counts supersede all aggregate historical figures:

| Workflow | Executions | Split | Payload character |
|----------|-----------|-------|-------------------|
| wazuh-high-severity-to-iris | 68 | 65 FINISHED / 3 ABORTED | REAL OpenCanary alerts as recent as today |
| wazuh-flow-classb-to-iris | — | draft | not promoted |

Correction of record: prior phases characterized executions as healthcheck-only; that claim is RETRACTED. Delivery inside finished executions is intermittent — DFIR-IRIS name-resolution failures appear in execution logs. Investigation is backlog BCK-38-005; routing certification withheld this cycle (phase38-91 §4). Exports hash-pinned under `ops/evidence/p38-workflow-export/` (SHA256SUMS.txt current).

## 4. Alert Volume Statistics

| Measure | Value | Source |
|---------|-------|--------|
| Alert indices tracked | 22 daily `wazuh-alerts` indices in rotation window | index sweep |
| Recent daily ingest (alert tier) | ~44k docs / ~45 MB per day; today 47,834 docs / 54.2 MB by 21:00Z (~2,280 docs/h) | 85 §ingest |
| Archives tier | ~15 GB total across 11 daily archives; rejection defect recovering ~14k docs/day post-fix | 79 §4; 78 |
| Cluster state | GREEN — 3 nodes, 274 shards | live `_cluster/health` |

Volume trajectory stable month-over-month; no anomalous spikes requiring incident classification.

## 5. Backup Verification

Corrected-and-verified posture (retiring the stale "repository_missing" claim, drift D-03b):

| Repository | Type | Snapshots | Newest | Indices covered |
|------------|------|-----------|--------|-----------------|
| wazuh-backup | fs (/snapshots) | **42** | snap-20260825-2017 (today 20:17Z) | 56 |
| do-spaces | s3 (nyc3 bucket) | **85** | s3-snap-20260825-2047 (today 20:47Z) | 95 |

Both repositories fired TODAY. Retention deletions are restore-safe. IRIS-side dump chain (14-day) intact per evidence ledger.

## 6. Retention Status

- All 11 archive indices: HOT, policy condition_not_met — **zero deletions executed to date** (expected; no forced deletion performed).
- First expiry ETA **2026-08-29T21:00Z** (~1.8 GB relief against ~15 GB footprint).
- Plateau forecast without intervention: ~2026-09-12.
- Checkpoint scheduled 08-30; observation task BCK-38-010 includes a restorability spot-check of one expired index.

## 7. Capacity Analysis — the 84% Plateau

Disk **84%** (up from 83% intra-day), memory 75%, swap 64%. Analysis: growth pressure is concentrated in archives-tier accumulation awaiting first ISM relief; alert-tier ingest is flat (~45 MB/day). If the 08-29 wave executes on schedule, projected relief restores ~1.8 GB immediately and establishes the recurring deletion cadence that caps the plateau; if it slips, the plateau date pulls left toward mid-September and the capacity program (BCK-38-010 follow-through) must convert from watch to action. tmp filesystem at 1.6 GB/21% — see §8.

## 8. tmp Status

Cleanup cron line present exactly once in root crontab but **PENDING-FIRST-RUN** (next fire 2026-08-26 03:00 UTC since being added). Known scope gap persists: the line targets only `pip-*` while the dominant consumer class is `tmp.*` (~1.5 GB), so post-first-run reduction will be marginal until scope is widened. Trend-log script still has never persisted output (log file absent); usage reconstructed point-in-time instead. Details and exclusions in phase38-81 §§4–6.

## 9. Report-Governance Cycle

First full governance cycle completed this month:

- Corpus audited end-to-end: ~1,900 md files inventoried; 87 generated reports cataloged with sha256 (`catalog-reports.json/.csv`); 26 duplicate groups, 8 empty stubs, missing finals P1/P36 logged for cleanup batch.
- Contradictions cataloged CON-38-01…10; stale chains 10–12 queued for retirement (three major retractions issued THIS phase — see §11).
- Status taxonomy enforced going forward; validator found 48 legacy non-enum statuses (batch-fix gated behind migration apply).
- **CI now exists:** `ops/scripts/p38-report-ci.sh` (mode 0755) runs the report gate honestly — currently FAIL because secret patterns match known credential locations in historical reports; that FAIL is the correct signal until redaction lands.
- Templates shipped: 9 `.md.tmpl` under `generated/templates/`.
- Migration dry-run PASS 8/8 (1,851 rows, 0 collisions); APPLY deferred pending approval.

## 10. Blocker Review

| Blocker | Age | Owner | State |
|---------|-----|-------|-------|
| Bearer token disclosure (rotation open) | since discovery | SOAR-ops | P0, plan ready, approval-gated |
| 3 credential locations unredacted | since corpus audit | Governance | P0, locations pinned |
| Shuffle frontend exposure (iptables plan unapplied) | multi-phase | Infra/SOC | P0, gated plan ready (73 §Step1) |
| Field-limit proof | hours | Platform | Fix live; T+1 calendar verification |
| IRIS DNS delivery failures | discovered this cycle | SOAR-ops | P1 investigation opened |
| Migration APPLY approval | since dry-run pass | Governance | P1, rollback validated |
| RTO/RPO undefined; restore NO-GO; asset not on-box | standing | Platform+Lead | P1/P2 chain (90 §3 items 9, 15) |
| 013 offline / 015 flapping | 15h / recurring | Endpoint ops | P2 |
| Dashboards unbuilt | standing | Detection eng | P2 |

## 11. Corrections Issued This Month-Close

1. Field-error mechanism: decoder_order_size attribution (P36) **RETRACTED** → indexer-side archives template budget; fix applied.
2. Routing characterization "healthcheck-only / zero real" **RETRACTED** → real OpenCanary traffic through high-severity workflow; per-workflow counts replace the 796 aggregate.
3. "No snapshot repository registered" marked **STALE** → both repositories verified live and current today.
4. Fleet narrative standardized: registered(9)/active(8)/online-now triple; 015 explicitly flapping, never smoothed.

## 12. Billing Cross-Reference

Certification detail in phase38-91: capture VERIFIED, detection PROVEN, routing PARTIAL-UNVERIFIED (not certifiable), endpoints 8/10 billable-active lines (excl. retired 008 + offline 013; 015 judgment caveat), capacity constraint disclosed, evidence quality STRONG (hash-pinned exports + ledgers). Invoice language must not assert certified response automation this cycle.

## 13. Retrospective

**Went well**
- Three wrong beliefs were caught and corrected by measurement within one cycle (field mechanism, routing reality, backup posture) — the audit discipline paid for itself.
- Snapshot safety net proven current twice over (fs + offsite) before any retention deletion becomes necessary.
- Governance moved from prose to machine-checkable: catalogs, schema, templates, and an honest CI gate now exist.
- Canary/detection proof held up under independent corroboration (real honeypot traffic through automation).

**Went poorly**
- A misdiagnosis survived multiple phases (decoder vs. indexer) because error counters weren't instrumented early enough — cost: weeks of noise (~14k rejected docs/day).
- Routing was certified-by-assumption in earlier narratives; direct export analysis this cycle overturned it. Claims outran evidence.
- Credential hygiene regressed into the report corpus itself; the tooling created to catch truthfulness now correctly blocks sharing until redaction completes.
- Two endpoint stability issues (013, 015) lingered past first response; recovery playbooks lack owner-contact steps.

**Carried forward**
- Prove the fix tomorrow; rotate/redact/harden the three P0s; make IRIS delivery dependable; get migration approved; define RTO/RPO and rehearse restore.

## 14. Cross-references

Backlog: phase38-90 · Billing: phase38-91 · Scorecard: phase38-92 · Deployability: phase38-94 · Release: phase38-95 · Repo: phase38-96 · Drift reconciliation: phase38-89.
