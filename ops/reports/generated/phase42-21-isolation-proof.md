# Phase 42 Synthetic-Isolation Proof — PARTIAL: Markers PASS, Isolation Branch Gated

**Report ID:** phase42-21-isolation-proof
**Phase:** 42
**Title:** ISO-42-01 — BLOCKED-DEPENDS-ON-GATES With Honest Partial Credit: Zero Contamination PROVEN By Markers/Status Across All P41–P42 Traffic (Every Event Synthetic/Test-Titled; Trigger Stopped; Estate 3); The Programmatic Isolation Branch Itself Remains Input-Blocked (T1)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:20:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (markers PASS; branch gated)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-21-isolation-proof.md`

---

## 1. (a) Designed protocol — preserved

1. Every synthetic fire carries `MCT_SYNTHETIC=true` + `MCT_TEST_ID` markers;
   IRIS alert titles tagged (`P41 packet-routing proof`).
2. Programmatic gate: synthetic-isolation-check python node evaluates the
   marker and would route non-marked traffic to SINK-synthetic-logonly.
3. Post-run contamination sweep: IRIS case/alert query by test tag; monitor
   counters reconcile; production counters untouched.

## 2. (b) What WOULD validate it

A marked event delivered AND an unmarked event refused by the isolation node
itself — proving the branch decides on content.

## 3. (c) Current partial evidence [VERIFIED]

- **Contamination: ZERO across all packet-lane traffic.** All 18 lifetime
  executions webhook-sourced during test windows only (04:15–04:28Z Aug 26);
  trigger `stopped` between tests [VERIFIED live this session];
  IRIS-side artifacts all test-titled [phase41-46 §4].
- **Branch itself: input-blocked.** T1/T2 (c69ebb73/bc6197a4): the
  python isolation node cannot read the marker field; its pass-through today
  is undefined-input behavior, not a security decision.
- Monitor accounting reconciles exactly with API pulls both phases
  [phase41-50; phase42-29].

## 4. (d) Unblock condition

Reference consumption in Tools (options A/B) so the marker check becomes a
real decision; or option C, where Wazuh-side tagging/filtering makes Shuffle
isolation structurally irrelevant for lane admission. Marker discipline stays
mandatory either way.
