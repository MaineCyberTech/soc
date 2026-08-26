# Phase 40 Packet Downstream-Failure Protocol — DNF-PKT-01

**Report ID:** phase40-51-packet-downstream-failure
**Phase:** 40
**Title:** Downstream-Failure Protocol (BLOCKED) — IRIS/Test-Endpoint Unreachable → No False Success, Destination Status Captured, Duplicate-Storm Avoidance, Safe Recovery; Class-A FINISHED≠Delivered Precedent
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:40:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** DNF-PKT-01
**Record-ID note:** tasking listed "DSF-PKT-01" for both 50 and 51; this report uses
DNF-PKT-01 to keep record IDs unique per corpus consistency rules (phase38-38 class)
— disambiguation recorded here.
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-51-packet-downstream-failure.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)

---

## 1. Blocker

Workflow absent from platform (IMP-40-01); no downstream-failure injection has ever
run against the packet lane. Expectations pre-committed. **No simulated PASS.**

## 2. Real-World Precedent on This Estate

The Class-A (Zeek) lane's IRIS DNS-failure era proved that a workflow can report
FINISHED while delivery silently failed — the FINISHED≠delivered lesson drove the
delivery-monitor design (phase39-29/-33/-34; re-proven for the webhook lane in
FAIL-40-01: DNS error excerpts, wrong-URL 404 class, "Skipping lines" parsing,
triple recovery without replay). This protocol pre-commits the packet lane to the
same standard: **workflow status alone is never treated as delivery proof.**

## 3. Failure Definition + Injection

| Case | Injection |
|---|---|
| DN1 IRIS unreachable | `docker network disconnect shuffle_swarm_executions iriswebapp_nginx` — known-good, proven in P39 layer-1 era and FAIL-39-02 M3 |
| DN2 wrong destination | point route URL at a closed port (test copy only) → 404/conn-refused class |

## 4. Expected Behavior

| # | Property | Pass condition |
|---|---|---|
| X1 | No false success | HTTP action fails ⇒ run takes failed arm; terminal = `DEADLETTER-target-fail`; `done-routed-log` is NEVER reached; execution never counts as delivered |
| X2 | Destination status captured | dead-letter log line carries HTTP/error class (status code or connect-error text) from the action result; recoverable from execution record without guesswork |
| X3 | Zero partial writes at IRIS | alert-row delta == 0 across the outage window (POST either lands whole or not at all; no partial-alert state) |
| X4 | Duplicate-storm avoidance | NO automatic retry loop: frozen design attempts once (timeout 10 s) and terminates via failed arm. P40 policy: if any retry is added, exactly ONE attempt with backoff ≥60 s, then dead-letter — never tight-loop, never per-worker fan-out retries |
| X5 | Recovery safe | reconnect ⇒ single marked replay routes normally; no duplicate rows when replay occurs after TTL expiry (see §5 honesty note) |

## 5. Honest Disclosure — Key-Consumption Ordering Limitation

Frozen topology: dedup-set succeeds BEFORE the route attempt. A DN failure therefore
consumes the dedup key: an immediate manual replay INSIDE the TTL window would be
suppressed despite non-delivery (visible as DUP-SUPPRESSED — not silent, but
undelivered). Handling:
- interim procedure (frozen build): operator replays only AFTER TTL expiry;
- amendment option (decide at import session): reorder commit so suppression is
  only durable after a successful route acknowledgement, or add explicit
  delivery-reconciliation note to the dead-letter path;
- whichever lands becomes part of REPLAY-PKT-01 step 4 regression coverage.

This limitation is disclosed NOW rather than discovered during an incident.

## 6. Proof Protocol

1. Baseline snapshot (IRIS count, counters).
2. Inject DN1 → submit marked canary → assert X1–X4 (terminal node, error text in
   log line, row delta 0, exactly one delivery attempt visible in action I/O).
3. Restore network → wait ≥TTL+margin → replay same event → assert single new row,
   normal terminals (X5).
4. Repeat once with DN2 (test-copy workflow) for the 4xx-class capture variant.
5. Export executions + psql dumps to `ops/evidence/p40-packet-runtime/dst-down/`;
   hash into successor report; per-cell verdicts from real runs only.

## Verdict

**DNF-PKT-01: BLOCKED — EXPECTATIONS PRE-COMMITTED INCLUDING THE ORDERING
LIMITATION AND ITS MITIGATIONS.** Estate precedent (FINISHED≠delivered) is baked
into acceptance criteria rather than assumed away.
