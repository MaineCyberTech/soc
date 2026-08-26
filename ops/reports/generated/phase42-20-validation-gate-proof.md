# Phase 42 Validation-Gate Proof — BLOCKED-DEPENDS-ON-GATES

**Report ID:** phase42-20-validation-gate-proof
**Phase:** 42
**Title:** VALPRF-42-01 — BLOCKED-DEPENDS-ON-GATES: Required-Field Validation Protocol Preserved Intact From P41; Node Executes Error-Free But Sees Undefined Input (T1), So It Cannot Detect Malformedness; Partial Credit = Happy-Path Execution + Structural Wiring
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:19:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-DEPENDS-ON-GATES
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-20-validation-gate-proof.md`

---

## 1. (a) Designed protocol — preserved from prior phases

1. Fire valid synthetic EVE-shaped event at webhook `p39-suricata-test`;
   assert validate-required-fields passes → chain proceeds to IRIS 200.
2. Fire field-deficient payload (documented shape: missing required EVE
   fields); assert validation flags → route to DEADLETTER-malformed; **NO**
   IRIS HTTP node result in stored results.
3. Assert monitor-side consistency: execution FINISHED but NOT counted
   delivered (no HTTP200-in-results) [phase41-37 guard].
4. Positive control adjacency + teardown estate check (3 workflows).

## 2. (b) What WOULD validate it

A single run where the node's decision demonstrably depends on event content:
valid → pass, deficient → DEADLETTER, with monitor accounting agreeing.

## 3. (c) Current partial evidence [VERIFIED]

- Node executes error-free in all 12 FINISHED runs of the P41 triplet arc;
  err-nodes=0 throughout [phase41-46].
- Structural wiring to DEADLETTER-malformed present in live def [phase41-47].
- **But**: T1/T2 prove the node sees UNDEF input and literal params
  (c69ebb73/bc6197a4) — any behavioral test today would measure undefined-
  input artifacts, not validation logic. No theater evidence was collected.

## 4. (d) Unblock condition

Any path restoring reference consumption into Tools (platform upgrade B),
or a UI-authored binding that consumes references (option A), or moving the
validation decision upstream of Shuffle entirely (option C). Then re-run §1
verbatim; nothing in the protocol ages.
