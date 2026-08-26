# Phase 42 Packet Volume Window — Protocol Defined; Live Numbers Pulled

**Report ID:** phase42-29-packet-volume-window
**Phase:** 42
**Title:** VOL-WIN-42-01 — COMPLETE: Volume-Window Protocol Defined; Live API Pull Shows Packet Lane e133a645 Lifetime = 18 Executions (12 FINISHED Proof Triplets 04:21–04:28Z + 6 Debug-Era ABORTEDs 04:15–04:18Z), ALL Aug-26 DEBUG/TEST Traffic, Zero Movement Since — Documented As DEBUG-Era Only
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:28:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-29-packet-volume-window.md`

---

## 1. Protocol (defined this phase for recurring use)

1. Pull `GET /api/v1/workflows/e133a645…/executions?limit=500` per session.
2. Classify by status and execution_source; convert epoch `started_at` → UTC.
3. Window filter for "today"; reconcile against monitor accounting.
4. Label any traffic outside an approved proof window as DEBUG-era and exclude
   from all production volume baselines (lane is TEST-ONLY; synthetic markers
   mandatory).
5. Alert condition for future windows: any packet-lane execution while the
   trigger is stopped or outside a declared test window = investigation.

## 2. Live pull — 2026-08-26T08:13Z [VERIFIED live]

Lane e133a645 (`suricata-packet-routing`): **18 executions lifetime returned,
all `execution_source=webhook`, all today (Aug 26), zero since 04:28:21Z.**

| Batch start (UTC) | × | Status | Latency |
|---|---|---|---|
| 04:15:17Z | 3 | ABORTED | 3–4s |
| 04:18:32Z | 3 | ABORTED | 3–7s |
| 04:21:27Z | 3 | FINISHED | 22–24s |
| 04:23:25Z | 3 | FINISHED | 19–21s |
| 04:25:36Z | 3 | FINISHED | 18–20s |
| 04:27:57Z | 3 | FINISHED | 21–24s |

Totals: 12 FINISHED (proof triplets) + 6 ABORTED (debug-era rebuild rounds;
causal FAILURE nodes parse-eve-json / normalize-fields, disclosed phase41-46).

## 3. Classification & reconciliation

All 18 executions are **DEBUG-era/test traffic only**: yesterday's P41 debug
rounds plus the same morning's proof arc, unchanged since. Counts reconcile
exactly with the P41 volume window (phase41-50 reported identical 18/12/6)
and with monitor accounting — no unexplained movement in either direction.

## 4. Baseline statement

Zero packet-lane traffic counts toward any production baseline, scorecard, or
billing figure. The lane's volume contribution to production is exactly zero
while TEST-ONLY holds (verified live: trigger stopped).
