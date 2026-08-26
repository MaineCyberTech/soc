# Phase 41 Delivery-Monitor Day Baseline — Window Definition And Overnight Run Inventory

**Report ID:** phase41-35-monitor-day-baseline
**Phase:** 41
**Title:** MON-BASE-41-01 — Complete-Day Evidence Window Defined (Contiguity Criteria + Slot Map); Overnight Monitor Log Inventoried Live: 14 Cycles On Disk, Zero Silent Skips, One Transport-Error Cycle, Totals Advanced 40→46 Mid-Window
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:22:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-35-monitor-day-baseline.md`

---

## 1. Purpose

Baseline record for the delivery-monitor day arc (reports 35–40): fix what a
"complete day" of evidence means before auditing it, and inventory the real
overnight log content rather than asserting it.

## 2. Complete-day window criteria (binding for MON-CERT-41-01)

A complete-day certification may only be claimed when ALL hold:

1. **Contiguity:** every */15 cron slot from T₀ to T₀+24h produced observable
   monitor output — either a `== ALERT-39-01 SUMMARY ==` block or an explicit
   ERROR/SKIP line. A silent missing slot breaks contiguity.
2. **Accounting stability:** each cycle's totals reconcile against the
   independent per-execution API classification (fresh script re-run), with
   deltas explainable by named new executions only.
3. **Guard liveness:** the false-FINISHED guard (delivered ⇔ HTTP200-in-results;
   `success": false` ⇒ FAILED) demonstrably armed throughout — no FAILED-class
   execution counted as DELIVERED in any audited cycle.
4. **Fail-closed transport:** any cycle lacking API response exits non-zero with
   an ERROR line (never fabricates counters).

## 3. Overnight log inventory [VERIFIED live]

Log: `ops/reports/shuffle-delivery-monitor.log` (cron `*/15`, active since
~01:45Z Aug-26, script `p39-iris-delivery-check.sh` hardened P40: flock,
.env-sourced token, secret-free). Pulled live 05:14–05:19Z.

The log carries **no per-line timestamps** (cron redirect, bare script echo);
cycle positions therefore map to slot times under the 01:45Z activation
recorded at schedule install. 40 log lines = **14 cycles**:

| Cycle | Slot (reconstructed) | Output class | eb937a37 | e951db98 | Summary totals |
|-------|----------------------|--------------|----------|----------|----------------|
| 1–10  | 01:45Z → 04:00Z      | SUMMARY      | exec=77 delivered=39 failed=31 aborted=3 other=4 | exec=1 delivered=1 | delivered=40 failed=31 aborted=3 |
| 11    | 04:15Z               | **ERROR only, exit 2** (`no API response for eb937a37…`) | — | — | none emitted (fail-closed) |
| 12–14 | 04:30Z → 05:00Z      | SUMMARY      | exec=83 delivered=45 (unchanged F/A/O) | exec=1 delivered=1 | **delivered=46 failed=31 aborted=3** |

Delta event: +6 executions, all delivered, on eb937a37 between the 04:00Z and
04:30Z cycles — consistent with the lane's newest execution started_at
04:13:26Z observed in the live API pull (report 50). Counters otherwise frozen
overnight, as expected for an idle night.

## 4. Honest limitations

- Slot times are reconstructed from the recorded activation time, not read
  from the log — the script prints no clock. Fixing this belongs to the
  hardening proposal (phase41-39 adds a staleness watchdog; per-line timestamps
  remain a P42 candidate).
- One cycle (04:15Z slot, reconstructed) failed transport and emitted no
  summary. Under criterion 1 this is *observable* (ERROR line exists), so it
  does not break contiguity — but it is counted, not hidden.

## 5. Hand-off

Run-audit quantifies adherence (phase41-36); false-FINISHED audit runs the
script fresh (phase41-37); certification consumes criteria §2 verbatim
(phase41-40).
