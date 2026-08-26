# Phase 42 Replay Proof — PARTIAL: Delivery Path Stands, Suppression Gated

**Report ID:** phase42-24-replay-proof
**Phase:** 42
**Title:** RPL-PRF-42-01 — BLOCKED-DEPENDS-ON-GATES With Strong Partial Credit: Replayed-Triplet Delivery Remains Proven (12 FINISHED, IRIS 200 ×12, Zero Function Errors); Replay *Suppression* Leg Waits On Working Dedup Gates; No New Fires This Phase By Design
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:23:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (delivery proven; suppression gated)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-24-replay-proof.md`

---

## 1. (a) Designed protocol — preserved

1. Fire four identical webhook triplets in sequence.
2. Assert every execution FINISHED, err-nodes=0, exactly one HTTP-200 IRIS
   result per run.
3. Suppression leg: assert copies 2–3 of each triplet suppressed by the dedup
   gate (depends on phase42-22).
4. Contamination sweep + estate check.

## 2. (b) What WOULD validate it

§1–2 passing again post-unblock AND §3 holding: later identical copies
refused while first copies deliver.

## 3. (c) Current partial evidence [VERIFIED]

- Delivery path: **proven end-to-end** in P41's live arc — four triplets
  04:21:27→04:27:57Z, 12/12 FINISHED, per-exec latency 18–24s (avg ≈21.25s),
  IRIS `{"status":200,"success"}` ×12 [phase41-46 §1–2].
- Lifetime ledger re-pulled live this session and UNCHANGED: exactly 18
  executions on e133a645 (12 FINISHED / 6 ABORTED debug-era), zero new
  traffic since 04:28:21Z — no drift since the proof [phase42-29].
- Suppression leg: gated behind dedup (phase42-22); three-deliveries-per-
 triplet remains the honest observed behavior under static keys.

## 4. (d) Unblock condition

Dedup gate operational (options A/B) → rerun full protocol including §3;
under option C suppression is manager-side and replay validation re-targets
that layer with Shuffle reduced to delivery.
