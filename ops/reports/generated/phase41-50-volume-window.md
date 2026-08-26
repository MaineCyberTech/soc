# Phase 41 Volume Window — Today's Execution Statistics From Live API

**Report ID:** phase41-50-volume-window
**Phase:** 41
**Title:** VOL-WIN-41-01 — Live Window 00:57–04:28Z Aug-26: Class-A Lane 9 Executions (All FINISHED, Avg Latency 4.7s); Packet Lane 18 Test Executions (12 FINISHED Avg ~21s, 6 Debug-Era ABORTED); Totals Reconcile Against Monitor Accounting Exactly
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:53:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-50-volume-window.md`

---

## 1. Method

Executions pulled live per lane via API (limit 500/100), filtered on
`started_at ≥ 2026-08-26T00:00:00Z` (epoch 1787702400). Latency proxy =
`completed_at − started_at` (hook-to-terminal where hook time ≈ start; true
hook-receipt offset not separately instrumented — stated limitation).

## 2. Class-A lane eb937a37 [VERIFIED live]

- Lifetime returned: 83 (matches monitor's executions=83 exactly).
- **Today: 9 executions, all FINISHED**, spanning 00:57:13Z → 04:13:26Z.
- Today avg latency: **4.7s**.
- Reconciliation: monitor saw lifetime move 77→83 (+6) mid-window; today-count
  arithmetic consistent with 3 pre-monitor activations before ~01:45Z.

## 3. Packet lane e133a645 [VERIFIED live]

- **Today: 18 executions, all webhook-sourced** (test fires):
  - 12 FINISHED in four identical triplets, 04:21:27–04:28:21Z,
    per-exec latency **18–24s, avg ≈21.25s** (13-node chain incl. IRIS call);
  - 6 ABORTED in two debug-era triplets 04:15–04:18Z (causal FAILURE nodes,
    disclosed in phase41-46).
- Overall latency spread incl. aborts: min 3s / max 24s / avg 15.7s.

## 4. Observations worth keeping

- Chain depth costs latency: 2-action Class-A ≈5s vs 13-action packet chain
  ≈21s (~+1.3s/node marginal) — baseline for future SLA talk.
- Zero traffic outside test windows overnight; both lanes idle 04:28Z→pull time.
- e951db98 (classb draft): lifetime single execution, none today — consistent
  with its dormant status.

## 5. Limitations

Latency uses Shuffle start/completion stamps, not webhook-arrival timestamps;
sub-second hook offsets invisible. Counts are API-window counts, not
deduplicated business-event counts.
