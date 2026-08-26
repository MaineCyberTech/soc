# Phase 40 Packet Datastore-Failure Protocol — DSF-PKT-01

**Report ID:** phase40-50-packet-datastore-failure
**Phase:** 40
**Title:** Datastore-Failure Protocol DSF-PKT-01 (BLOCKED) — Read-Fail / Write-Fail / Counter-Fail Cases → Fail-Closed + Operator Notice + Evidence Retention + Clean Recovery; Guardrail Independence Assertion
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:38:30Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** DSF-PKT-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-50-packet-datastore-failure.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)
**Companion to:** FAIL-39-02 case M2 (phase39-41), expanded for Phase 40

---

## 1. Blocker

Workflow absent from platform (IMP-40-01); no datastore-failure injection has ever
run against this lane. Cases and expectations pre-committed. **No simulated PASS.**

## 2. Scope: What "Datastore" Means Here

Workflow state (dedup keys, counters, minute-markers) lives in Shuffle's datastore,
backed by `shuffle-opensearch` on this estate. All packet-lane persistent controls
(45–46) depend exclusively on this store — nothing else holds authoritative state.

## 3. Failure Case Matrix

| Case | Injection (known-good family) | Expected workflow behavior |
|---|---|---|
| DF1 read-fail | scale `shuffle-opensearch` to 0 replicas/down BEFORE submitting marked canary | explicit get_state errors → **fail-closed**: divert to TARGETFAIL-family dead-letter with error text; NEVER treated as "unique → route" and NEVER as "duplicate → suppress" |
| DF2 write-fail | restore reads but block writes (e.g., partial recovery window or worker-to-store disconnect) | get succeeds (not-found) but set_state fails → **fail-closed dead-letter**; event is NOT routed un-deduplicated even though it looked first-seen |
| DF3 counter-fail | datastore healthy for keys but counter write blocked (same class, targeted) | increment failure after dedup-pass → **fail-closed dead-letter BEFORE the route action executes** (counter sits upstream of route in frozen topology — ordering is the safety property) |

Universal rule: a datastore fault can change WHERE a run ends, never WHETHER an
unprotected side effect occurs. During any DF case: zero IRIS writes, zero counter
movement, zero new durable keys.

## 4. Operator Notice + Evidence Retention

- Each DF run leaves: FINISHED-via-dead-letter execution record containing the raw
  payload and the datastore error text (evidence retained by platform).
- Aggregate: `p40_packet_dstfail_<YYYYMMDD>` day-bucket increments; thresholded
  operator notice per phase40-43 §5 machinery (bounded, single emission per window).
- Post-window review requires: list of affected execution IDs + error classes —
  recoverable entirely from execution history without external logging.

## 5. Recovery Cleanliness

1. Restore backing service to steady state.
2. Submit one marked canary → routes normally (fresh key; counters resume from
   pre-failure values — persistence survived the outage).
3. NO re-seeding required: dedup/counters hold no cross-system caches that could
   desynchronize; the outage cannot have created phantom duplicates or lost
   suppressions that matter post-recovery (worst case during outage: events were
   dead-lettered, i.e., visible, not silently dropped).

## 6. External-Guardrail Independence Assertion

> The datastore subsystem under test is internal to the Shuffle deployment.
> Wazuh availability, IRIS availability, DNS, and inter-lane network paths are
> INDEPENDENT of every DF case above: taking IRIS down does not affect dedup
> semantics; taking the datastore down cannot be masked by downstream health.
> Conversely, no external component can reset or bypass packet-lane state.
> This bidirectional isolation is the design basis for treating DSF-PKT-01 and
> DNF-PKT-01 (phase40-51) as separate, individually-passable proof gates.

## 7. Proof Protocol

1. Baseline snapshot (counters, IRIS count, scorecard hash).
2. Inject DF1 → submit canary → assert dead-letter terminal + error text captured
   + §3/§4 deltas == 0.
3. Restore; assert recovery step §5 (normal route, counters resumed).
4. Repeat sequence for DF2, DF3 (restore fully between cases).
5. Export executions + datastore dumps to `ops/evidence/p40-packet-runtime/dstfail/`;
   hash into successor report; per-cell verdicts only from real runs.

## Verdict

**DSF-PKT-01: BLOCKED — CASE MATRIX, FAIL-CLOSED SEMANTICS, NOTICE/EVIDENCE DESIGN,
AND RECOVERY PROCEDURE FULLY SPECIFIED.** Runtime verdicts pending import + live
injections.
