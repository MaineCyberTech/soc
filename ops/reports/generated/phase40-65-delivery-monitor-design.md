# Phase 40 Delivery Monitor Design

**Report ID:** phase40-65-delivery-monitor-design
**Phase:** 40
**Title:** Design MON-40-01 — Shuffle→IRIS Delivery Monitor: Accounting Model, FINISHED-vs-Delivered Distinction, Execution-Id Dedupe, Thresholds, State Storage, Runbook & Owner
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:31:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-65-delivery-monitor-design.md`

---

## 1. Purpose

Continuously classify recent Wazuh→IRIS workflow executions so silent delivery
degradation is detected within ≤15 minutes without human log diving.

## 2. Accounting model (canonical)

Per execution, scan stored action results:

| Class | Rule |
|---|---|
| **DELIVERED** | Terminal status FINISHED **and** an action result parses to HTTP `status:200` with body `{"status":"success"}` |
| **FAILED** | Terminal FINISHED whose result bears `success:false` (ConnectionError / HTTP error class) |
| **ABORTED** | Terminal status ABORTED — counted separately, never merged into FAILED |
| **OTHER** | Anything else (RUNNING, NOT_EXECUTED, unparseable) — surfaced, never silently dropped |

## 3. Core lesson encoded: FINISHED ≠ delivered

Shuffle reports workflow-level status; a workflow can end FINISHED while its
IRIS HTTP step failed inside a branch. The monitor's contract is therefore:
**only result-parsed HTTP 200 + success body counts as DELIVERED.** Workflow
status alone is never trusted. This distinction is why historical "green"
periods coexisted with real failures.

## 4. Duplicate handling

One output row per `execution_id`; re-scanning the same tail window is idempotent
because classification is derived from immutable execution records, and the
append-log dedupe key is `execution_id` (same id never double-counted across
runs within a window). The summary line is recomputed per run from the API,
not accumulated incrementally — drift-proof.

## 5. Latency capture

Each row prints `last_failed_started_at` (epoch of newest failed/aborted
execution) giving detection-to-event distance; full per-execution latency
(started_at→finished_at delta) is available in the API payload and reserved
for a future v2 field (documented extension point, not yet needed).

## 6. Alert thresholds

| Trigger | Response |
|---|---|
| failed-rate >20% of executions in window | NOTICE entry in monitor log summary (operator reviews at cadence) |
| Any new ABORTED burst (>0 vs prior baseline of 3 historical) | NOTICE — aborts historically indicate manual kills or infra faults |
| Script exit 2 (transport/auth error) | Line `ERROR: …` in log — cron continues; two consecutive errors = investigate backend |

Notification channel = **log-append only** (no email configured — documented
limitation, see phase40-68 §4c; optional `mailx` upgrade noted there).

## 7. State storage

Append-only host log:
`ops/reports/shuffle-delivery-monitor.log`
(one multi-line block per run ending in
`== ALERT-39-01 SUMMARY: delivered=N failed=N aborted=N other=N ==`).
No database; the log IS the state. Rotation via logrotate snippet (phase40-66).

## 8. Runbook & owner

- Operational runbook: **phase39-33** (monitor origin, interpretation guide).
- Design record: this file. Implementation record: phase40-66.
  Schedule record: phase40-67. Test evidence: phase40-68.
- **Owner: MCT SOC (automation: opencode/ox-alpha)**.
