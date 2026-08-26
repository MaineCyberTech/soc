# Phase 42 Malformed-Input Proof — BLOCKED-DEPENDS-ON-GATES

**Report ID:** phase42-25-malformed-proof
**Phase:** 42
**Title:** MALF-PRF-42-01 — BLOCKED-DEPENDS-ON-GATES: Malformed-Event Protocol Preserved Verbatim; Fail-Closed Wiring Structural (DEADLETTER-malformed Present, AGENTS MUST Honored In Design) But Validate Gate Cannot Behaviorally Route While Input Is Undefined (T1); No Injection Test Run By Policy
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:24:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-DEPENDS-ON-GATES
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-25-malformed-proof.md`

---

## 1. (a) Designed protocol — preserved verbatim from P41 [phase41-47 §4]

1. Fire payload missing required fields (documented shape) at the webhook.
2. Assert: validate node flags → route to DEADLETTER-malformed → terminal
   logonly sink; NO IRIS call (absence of HTTP-200 node result).
3. Assert monitor-side: execution FINISHED but NOT counted delivered — guard
   consistency with phase41-37.
4. Positive control: adjacent valid event still routes to IRIS 200.
5. Teardown: estate exactly 3 workflows; contamination markers intact.

## 2. (b) What WOULD validate it

The routing decision demonstrably flipping on payload shape only (deficient →
DEADLETTER, valid → IRIS), with monitor accounting agreeing.

## 3. (c) Current partial evidence [VERIFIED]

- Structure proven: `DEADLETTER-malformed` present in live def with branch;
  fail-closed design intent documented and enforced in review [phase41-47].
- Behavior blocked: validate-required-fields sees UNDEF input (T1,
  c69ebb73) — any outcome from a live malformed fire would be an artifact of
  undefined-input behavior, not validation. Running it for theater would
  violate the no-simulation rule; no injection was performed.

## 4. (d) Unblock condition

Reference consumption in Tools (options A/B) then run §1 as written; under
option C malformedness filtering happens Wazuh-side before forwarding and the
protocol re-targets the pre-filter with Shuffle DEADLETTER retained for
defense-in-depth.
