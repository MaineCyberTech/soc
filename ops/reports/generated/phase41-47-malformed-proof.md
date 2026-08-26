# Phase 41 Malformed-Input Proof — Protocol Recorded; Behavioral Gate Blocked

**Report ID:** phase41-47-malformed-proof
**Phase:** 41
**Title:** MALF-PRF-41-01 — BLOCKED-PARTIAL: Malformed Path Exists Structurally (DEADLETTER-malformed Wired, Fail-Closed Design Honored) But The Validate Gate Cannot Behaviorally Route Anything While Its Input Is Undefined; Test Protocol Staged For Post-Fix Session
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:47:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-PARTIAL
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-47-malformed-proof.md`

---

## 1. Structural evidence [VERIFIED]

The malformed branch exists and is wired: node `DEADLETTER-malformed`
(Tools repeat_back_to_me logonly sink) present in the live inventory with its
branch; the chain's intended semantics are fail-closed per AGENTS MUST
("Fail closed on malformed, unknown, or datastore-failure events").

## 2. Behavioral gate — untestable today [BLOCKED]

Routing a malformed event to DEADLETTER requires `validate-required-fields`
to actually detect malformedness. On this build that node's execute_python sees
undefined input (platform blocker, root cause phase41-44 §2), so it cannot
gate: feeding it a malformed payload would prove nothing — any outcome would be
an artifact of undefined-input behavior, not of validation logic.

## 3. What would make the test meaningful again

Same unblock pair as dedup/counter: native-reference rebuild (owner UI
session) or platform fix. Until then NO malformed-injection test is run —
running one to collect theater evidence would violate the no-simulation rule.

## 4. Staged protocol (executes the moment the gate works)

1. Fire payload missing required fields (documented shape) at the webhook.
2. Assert: validate node flags → route to DEADLETTER-malformed → terminal
   logonly sink; NO IRIS call (absence of HTTP-200 node result).
3. Assert monitor-side: execution FINISHED but NOT counted delivered (no
   HTTP200-in-results) — guard consistency with phase41-37.
4. Positive-control: adjacent valid event still routes to IRIS 200.
5. Teardown: verify estate 3 workflows; contamination markers intact.

## 5. Verdict

Structural readiness: PROVEN. Behavioral enforcement: BLOCKED, honestly, with
the exact test ready to run when unblocked.
