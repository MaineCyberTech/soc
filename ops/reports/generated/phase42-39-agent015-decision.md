# Phase 42 Agent 015 Decision — PARTIAL Split Stands

**Report ID:** phase42-39-agent015-decision
**Phase:** 42
**Title:** DEC-015-42-01 — Standing Verdict PARTIAL With An Evidence-Based Split: Permission Gate CLOSED-DURABLE (Proven By Zero merged.mg Errors Since Fix), Sleep-Flap Gate OPEN-BY-REALITY (Device-Side Action Pending); Split Is Not Softness — Each Half Carries Its Own Proof Class
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:01:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (split verdict standing)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-39-agent015-decision.md`

---

## 1. Status

**PARTIAL — split stands.** Agent 015 presents two independent gates that fail
in different ways and close with different proof classes. Collapsing them into
one aggregate status would either overclaim (calling the flap fixed) or
underclaim (re-opening the proven permission closure). The split is the honest
shape.

## 2. Decision matrix

| # | Gate | Required proof class | State today | Color |
|---|---|---|---|---|
| P1 | merged.mg permission closure | Absence-of-error over time since fix | Manager logs since 2025-08-25T00:00Z scan: **0** merged.mg errors (live check 2026-08-26); zero since fix applied in P40 arc | **GREEN-CLOSED** |
| P2 | Sleep-flap closure | 24h clean window per phase42-38 | Window not started — no remediation applied; live pull shows asleep-at-pull pattern (LKA 06:58:49Z, disconnected at 08:49:39Z pull) | **RED-OPEN** |
| P3 | Config-sync | Central config = applied config | Verified in P40 config-delivery arc; unchanged since | GREEN |
| P4 | Telemetry quality | Graded during active windows only | Deferred-by-design until P2 closes | N/A-PENDING |

## 3. Verdict rules

- Overall = worst of P1/P2 while P3 green: currently **PARTIAL**.
- P1 stays GREEN-CLOSED unless a new merged.mg error appears — its durability,
  not a snapshot, is what was proven.
- Overall flips CERTIFIED only when P2 passes its full 24h window AND P4 gets
  graded during a genuine active window. Neither can be rushed.

## 4. Why the split matters downstream

Fleet reporting consumes per-gate states: the permission closure counts as a
banked fix (it survives regardless of the flap), while the flap correctly keeps
015 off any "fully healthy endpoint" list. One number would destroy exactly
this distinction.

## 5. Path to whole-green

Owner applies phase42-37 package (slot T+10) → phase42-38 clock opens → 24h
clean → P2 GREEN → P4 graded next active window → overall CERTIFIED with every
gate carrying real evidence.
