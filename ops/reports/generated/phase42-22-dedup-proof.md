# Phase 42 Dedup Proof — BLOCKED-DEPENDS-ON-GATES

**Report ID:** phase42-22-dedup-proof
**Phase:** 42
**Title:** DEDUP-PRF-42-01 — BLOCKED-DEPENDS-ON-GATES: Dedup Protocol Preserved; check_datastore_contains Executes Error-Free But Its Key Ships Static Because Refs Pass Literal (T2) — Suppression Semantics Remain Unprovable; Partial Credit = Non-Suppression Of Triplets Is Itself Documented Platform Behavior
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:21:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-DEPENDS-ON-GATES
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-22-dedup-proof.md`

---

## 1. (a) Designed protocol — preserved from P41 [phase41-44]

1. Flush datastore keyspace (test-scoped).
2. Fire event A (distinct synthetic content); assert datastore now contains
   key derived from A's resolved fields.
3. Fire identical A again; assert suppression branch (duplicate-suppressed-
   logonly) taken, NO second IRIS delivery.
4. Fire distinct B; assert delivered; key count = 2.
5. Teardown: flush keyspace, estate check.

## 2. (b) What WOULD validate it

Key contents differing per event in the datastore, and the second identical
fire NOT reaching IRIS while the distinct one does.

## 3. (c) Current partial evidence [VERIFIED]

- Node executes every clean run error-free; corrected append-argument form
  verified [phase41-44 §1].
- The key never resolves: T2 shows `$ref` params arrive literal
  (bc6197a4); therefore the checked value is a constant and step-2/3
  assertions are unmeasurable.
- Inverse evidence exists and is honestly logged: three identical triplets
  produced three deliveries each (12 FINISHED, no suppression observed)
  [phase41-46 §3] — consistent with static-key behavior, not contradicting
  the design.

## 4. (d) Unblock condition

Options A/B restoring reference consumption (then run §1 verbatim), or
option C where dedup moves to a manager-side custom integration script with
real event-state — in which case this protocol re-targets that component.
