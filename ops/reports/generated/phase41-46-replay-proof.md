# Phase 41 Replay Proof — REPLAY-PARTIAL: Delivery Path Proven End-To-End, Suppression Side Unproven

**Report ID:** phase41-46-replay-proof
**Phase:** 41
**Title:** REPLAY-PRF-41-01 — REPLAY-PARTIAL: Four Identical-Triplet Webhook Fires (12 Executions, 04:21–04:28Z) ALL FINISHED With Zero Function Errors And IRIS HTTP-200 Each Run; Suppression Semantics UNPROVEN By Platform Blocker; Contamination Check PASS
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:45:00Z
**Classification:** INTERNAL
**Status:** PARTIAL (delivery proven; suppression unproven)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-46-replay-proof.md`

---

## 1. Live execution evidence [VERIFIED live, pulled this session]

Lane e133a645 (`suricata-packet-routing`), all executions today,
all `execution_source=webhook`, fired as identical triplets:

| Batch (started_at) | Executions | Status | Per-exec latency |
|--------------------|-----------|--------|------------------|
| 04:21:27Z | ×3 | FINISHED | 22–24s |
| 04:23:25Z | ×3 | FINISHED | 19–21s |
| 04:25:36Z | ×3 | FINISHED | 18–20s |
| 04:27:57Z | ×3 | FINISHED | 21–24s |

(Preceding era, disclosed: two triplet batches at 04:15:17Z / 04:18:32Z ABORTED
during rebuild-debug — causal FAILURE nodes `parse-eve-json` /
`normalize-fields`; every fix landed before the 04:21Z batch.)

## 2. Delivery-path proof — what stands

Newest execution dissected node-by-node from stored results: **13 nodes with
results, zero non-success nodes, exactly one HTTP-200-success node** — the IRIS
route (`iris-test-route-p39tag`) delivering `{"status": 200, body success}`.
Pattern consistent across all 12 FINISHED runs: err-nodes=0, IRIS 200 each.
This is end-to-end delivery proof on the packet lane: webhook fire → full chain
→ IRIS accepted.

## 3. Suppression side — UNPROVEN, by design of honesty

Three identical events produced three deliveries per batch. Under a working
dedup, later copies should have been suppressed. They were not — and could not
be, because the dedup key never resolves (phase41-44). This report therefore
certifies **delivery-path correctness only** and explicitly does not certify
duplicate suppression.

## 4. Contamination check — PASS

Workflow status `test`; trigger `stopped`; every event synthetic/test-marked;
IRIS alerts titled `P41 packet-routing proof`; estate exactly 3 workflows;
probe workflow p41-varprobe deleted beforehand with datastore+cache flush;
stray p40-import-probe already cleaned. Zero production counters moved.

## 5. Verdict

REPLAY-PARTIAL is the strongest honest claim available: the lane delivers,
repeatably, cleanly, provably — it just cannot yet *refuse* anything.
