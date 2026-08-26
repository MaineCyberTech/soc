# Phase 41 Dedup Proof — BLOCKED-PARTIAL With Root-Cause Chain

**Report ID:** phase41-44-dedup-proof
**Phase:** 41
**Title:** DEDUP-PRF-41-01 — BLOCKED-PARTIAL: datastore-dedup-set Node Executes Every Clean Run But Suppression Semantics Are Unprovable Because The Key Never Resolves; Root Cause Traced To Platform-Level execute_python Input Defect
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:41:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-PARTIAL
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-44-dedup-proof.md`

---

## 1. What is proven [VERIFIED]

- The node exists (`datastore-dedup-set`, Tools `check_datastore_contains`),
  executes in every FINISHED run (absent only from SKIPPED sets of the two
  early-abort executions), and does not error — final rounds carry err-nodes=0.
- Iterative defect fixed en route: initial call lacked the append argument;
  corrected form includes `false` (check-only semantics) as designed.

## 2. What is NOT provable on this build [BLOCKED]

Suppression semantics require the dedup key to contain event-derived values so
repeat events match. They do not: the key expression ships static because the
platform cannot resolve references into it.

Root-cause chain (established empirically, probe workflow p41-varprobe —
created, exercised, deleted cleanly):

1. `execute_python` in this build exposes **no incoming-data variable**:
   data_in / input / execution_input / execution_data / all UNDEF; globals =
   modules + shuffle (Singul) + self (Tools).
2. Parameter injection into execute_python also fails: `$ref` arguments arrive
   as literals.
3. Therefore any key built via python normalization is built from undefined
   input or static text; `check_datastore_contains` then checks a constant —
   which proves nothing about duplicate behavior.
4. Cross-node python data-passing is impossible on this build for the same
   reason (each node sees UNDEF regardless of upstream output).

## 3. Consequence

No claim of duplicate-suppression functionality is made. The replay proof
(phase41-46) deliberately reports delivery-path success ONLY and marks the
suppression side UNPROVEN.

## 4. Unblock paths

(a) Owner UI session rebuilding the chain with natively reference-consuming
nodes (`filter_list` / `if_else_routing` / `set_datastore_value`, which DO
resolve `$refs` per Class-A precedent), or (b) Shuffle upgrade fixing
execute_python kwargs injection. Both carried into the decision record
(phase41-52).
