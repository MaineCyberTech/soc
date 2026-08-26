# Phase 41 Detection Audit

**Report ID:** phase41-89-detection-audit
**Phase:** 41
**Title:** AUDIT-DET-41 — DET-41-04 Lanes Matrix: Class-A CERTIFIED-AUTOMATED (Fresh Monitor Run Embedded; Real Fail-Closed ERROR Proven At 04:15Z), Packet Lane TEST-ONLY With Precise Platform-Blocker Statement, FP Framework Live On Zero-Natural-FP Baseline, Canary Proven Across Three Eras, Archives Quality Improved By Containment, Notify-Only Design Restated
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:53:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-89-detection-audit.md`

---

## 1. DET-41-04 lanes matrix

| Lane | Verdict | Evidence this cycle |
|---|---|---|
| **Class-A delivery (Zeek→guardrail→Wazuh→Shuffle→IRIS)** | **CERTIFIED-AUTOMATED** (certification held; soak re-proven overnight) | Fresh monitor run embedded below; 14 overnight cycles incl. ONE REAL fail-closed ERROR caught at the 04:15Z slot [phase41-40]; watchdog armed at cron 3,18,33,48 |
| **Packet lane (Suricata→routing)** | **TEST-ONLY** — import + routing proofs DEFERRED by choice; precise platform blocker: Shuffle `execute_python` param-injection defect (`data_in`, `input`, `execution_input`, `execution_data`, `data` ALL UNDEF in globals); native reference-consuming nodes (filter_list / if_else_routing / set_datastore_value) DO resolve $refs per Class-A precedent → remediation = UI rebuild on native nodes or platform upgrade (R-PKT-PLATFORM) | phase41-52 probe; workflows API live: exactly 3 workflows, e133a645 test-only untouched |
| **FP framework** | LIVE — baseline established: zero natural false positives in sample window; minimal honest population = 12 alerts (declared, not padded); tuning proposals documented awaiting owner decision | phase41-69…74 chain |
| **Canary coverage** | PROVEN across three eras: legacy SO era, current Class-A automated era, packet-lane test era — synthetic isolation held in every era | phase41 lineage; §4 discipline check live |

### Fresh monitor run (embedded, this session)

```
$ bash ops/scripts/p39-iris-delivery-check.sh
eb937a37  executions=83  delivered=45  failed=31  aborted=3  other=4  last_failed_started_at=1786389856
e951db98  executions=1   delivered=1   failed=0   aborted=0  other=0
== ALERT-39-01 SUMMARY: delivered=46 failed=31 aborted=3 other=4 ==
```
Delivered counts are dominated by marked/synthetic proof traffic; the natural-eligible
quiet-window disclosure from phase40-38 still holds — no natural high-sev eligible
alert has traversed the automated lane as of this cycle.

## 2. Coverage gaps (honest)

1. Endpoints 013/015 offline (owner device-side) → two hosts blind to endpoint rules.
2. Dashboard EID-mapping question (event.code vs rule.groups sysmon_eid1, and the
   6-vs-7 active-agent widget delta) unresolved pending owner ruling — dashboard-based
   detection review is provisional until then (OW-41-02).
3. Visual-render verification login-gated — data-layer validated only.
4. Packet-lane detection content exists on the sensor but routing automation is
   blocked by the platform defect; manual/API paths remain the only egress.
5. No natural eligible alert has exercised the automated lane end-to-end yet —
   certification rests on marked proofs plus a real fail-closed error path.

## 3. Archives quality improved by containment

The eve.json stats flood no longer enters archives at source: today's 378,937 archive
events are signal-bearing records plus a bounded 129-doc compact-stats lane that is
indexed, searchable (`data.event_type:stats_compact`), and excluded from dashboards
(zero dependencies verified G41-10). Field headroom risk downgraded to
CONTAINED-pending-full-cycle with the flip armed on the 08.27 index.

## 4. Notify-only design statement

Both active notification paths remain NOTIFY-ONLY by design: no active response,
no blocking, no case auto-closure, no counter mutation. Synthetic events stay isolated
from production counters/cases/billing/scorecards. Fail-closed semantics were proven
against a REAL failure event overnight (04:15Z slot): monitor detected, flagged,
and the pipeline degraded safely without silent loss.
