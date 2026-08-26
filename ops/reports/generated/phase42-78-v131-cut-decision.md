# Phase 42 v1.3.1 Cut Decision — REL-DEC-42-01

**Report ID:** phase42-78-v131-cut-decision
**Phase:** 42
**Title:** DECISION EXECUTED: CUT v1.3.1 — All Deltas Runtime-Stable Under Documented-Delta Model Since P40; Packet-Lane Blocker Is Platform-Side NOT Config-Side So Waiting Adds Nothing To The Tag; Containment Chain Belongs In A Tagged Baseline; Approver MCT-SOC-Process (Automation-Executed Per Pack Mission "Execute Or Explicitly Defer")
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:39:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-78-v131-cut-decision.md`

---

## 1. Decision record

| Field | Value |
|---|---|
| Decision | **CUT v1.3.1** — EXECUTED this cycle (execution record: phase42-79, REL-EXE-42-01) |
| Decision ID | DECISION-V131-42-01 (resolves the Phase-42-open cut fixed by DECISION-V131-41-01 / RELPLAN-41-01) |
| Approver | **MCT-SOC-process** — automation-executed under the pack mission "Execute or explicitly defer": both alternatives below were explicit, and deferral had no evidence-bearing benefit |
| Scope cut | D-1..D-12 exactly as registered (phase41-77 §2 + phase41-98 §3); packet-lane work stays OUT of the tag per standing contingency |
| Readiness input | phase42-77 verdict READY |

## 2. Rationale

1. **All deltas runtime-stable since P40.** Every item D-1..D-12 already runs in
   production under v1.3.0 via the documented-delta model (phase41-77 §4). The
   tag records reality; it introduces no new runtime state and therefore
   carries no stability risk requiring further soak.
2. **The packet-lane blocker is platform-side, not config-side** (R-PKT-PLATFORM,
   Shuffle execute_python param-injection defect — AGENTS.md Known Blockers;
   ROUT-PKT-41 TEST-ONLY). Waiting for its remediation adds nothing to THIS tag:
   no D-register row depends on it, and the contingency "cut with D-1..D-12 only"
   was pre-authorized precisely for this outcome (phase41-93; phase41-98 §3).
   Packet-lane moves to the v1.3.2 register.
3. **The containment chain belongs in a tagged baseline.** The P41 field-growth
   containment at source (template fieldlimit + sensor compact-stats chain,
   D-1/D-9), custody closure standard (D-12), monitor+watchdog (D-7/D-11) are
   load-bearing posture that should be reproducible from a named ref, not from
   working-tree memory.

## 3. Alternatives considered

| Alternative | Verdict | Reason rejected |
|---|---|---|
| Wait for packet-lane remediation before cutting | REJECTED | Blocker is platform-side; zero register rows depend on it; waiting delays a stable baseline indefinitely |
| Cut a larger v1.4 including untested future work | REJECTED | Violates minimal-delta release discipline; nothing staged beyond D-1..D-12 |

## 4. Execution pointer

Tag creation, push, on-box asset build, MANIFEST, and publication-blocker
handling: **phase42-79-v131-execute.md** (REL-EXE-42-01). Assurance:
**phase42-80-v131-assurance.md** (REL-ASR-42-01).
