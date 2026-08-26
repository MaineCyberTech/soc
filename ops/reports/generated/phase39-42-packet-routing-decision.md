# Phase 39 Packet Routing Decision — ROUT-39-02

**Report ID:** phase39-42-packet-routing-decision  
**Phase:** 39  
**Title:** Packet/Suricata Lane Routing Decision — DEFERRED (Build API-Gated; Proofs Blocked) With Precommitted Preconditions, Limits, and Kill Switch  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** DEFERRED  
**Record ID:** ROUT-39-02  
**Author:** opencode/ox-alpha  
**Owner:** MCT SOC (automation: opencode/ox-alpha)  
**Review date:** Phase 40  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-42-packet-routing-decision.md`

---

## 1. Decision

> **DEFERRED.** The packet workflow is not importable via the raw API cleanly
> (`POST /api/v1/workflows` → 401 Unauthorized, differential GET proves key valid —
> WF-39-02 §4), so REPLAY-39-02 / FAIL-39-02 proofs are blocked. No packet routing is
> enabled in production this phase.

## 2. Candidate SIDs Restated

| Priority | SID | Basis |
|---|---|---|
| 1 | **2027967** | canary signature, E2E-proven P35; sole allowlist entry in the finalized artifact |
| 2+ | ET Open 544 curated population | expansion only after FP review of lane behavior at SID-1 |

## 3. Preconditions to Revisit (all required)

| # | Precondition |
|---|---|
| P1 | phase39-39 import executed via UI (or upgraded API path) — workflow exists, `status="test"` |
| P2 | REPLAY-39-02 executed for real: E1–E6 all pass |
| P3 | FAIL-39-02 matrix M1–M4 executed with zero IRIS side-effects and explicit terminal branches |

## 4. False-Positive Review Process (before allowlist expansion)

1. Run SID under test ≥7 days in test route only (`[p39-test]` titles).
2. Weekly triage: alert count, per-source distribution, analyst disposition.
3. Expansion requires: FP rate below agreed threshold + SOC sign-off entry in change
   register; one SID per review cycle.

## 5. Limits (at enablement)

- Rate cap suggestion: **50 alerts/min** into the lane (workflow-side counter check +
  integration-level rule narrowing); sustained breach = auto-disable candidate.
- Severity fixed mapping during test era; customer_id 1.

## 6. Kill Switch

Any of the following, effective immediately:
1. Remove/disable `rule_id` allowlist entry in the Wazuh integration block (CFG-39-01)
   → stops feed at source;
2. Shuffle UI workflow toggle OFF → drops executions regardless of feed;
3. Delete webhook binding.

Precedent on this estate: Zeek Class A integration disabled-by-guardrail comment block
in ossec.conf demonstrates the accepted kill-switch pattern.

## 7. Client Impact Assessment

Packet-alert volume expected modest relative to existing lanes: canary sid fires on
dedicated interaction paths only; ET Open candidates gated by FP review and rate cap.
No client-visible SLA surface depends on this lane in Phase 39.

## Verdict

**ROUT-39-02: DEFERRED to Phase 40.** Design/artifact work complete (BASE-39-01,
WF-39-02); execution proof chain resumes immediately after UI-gated import.
Owner: MCT SOC.
