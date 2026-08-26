# Phase 38-76 Packet Workflow Proof Methodology

**Report ID:** phase38-76-packet-workflow-proof  
**Phase:** 38  
**Title:** Phase 38-76 Packet Workflow Proof — Idempotency, Isolation, Failure-Safety Protocol  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T21:13:25Z  
**Classification:** INTERNAL  
**Scope:** Proof METHODOLOGY for the phase38-75 design; BLOCKED until workflow exists  
**Status:** BLOCKED  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Owners:** ["opencode/ox-alpha", "human-operator"]  
**Blockers:** ["phase38-75 workflow creation is UI/API-gated and not yet approved"]  
**Evidence Roots:** []  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-76-packet-workflow-proof.md`  
**Retention Class:** canonical-current  

---

## 1. Status

**BLOCKED pending workflow creation (phase38-75).** This document freezes the proof protocol so
that the moment the workflow exists (test status), verification can run without design drift.

## 2. Guardrail Independence Assertion

The synthetic-isolation guardrail MUST be proven independent of every other stage:

- **A1**: A `synthetic`-tagged event must reach SINK even if validation would have passed AND dedup state is empty AND IRIS target is healthy.
- **A2**: A `synthetic`-tagged event must reach SINK even if all upstream stages fail (feed garbage that still carries the tag) — tag check precedes routing logic.
- **A3**: No branch other than SINK may execute for tagged events — asserted from execution graph (`results[]` node list) in every replay below.
- **A4**: The isolation predicate reads ONLY the event's own fields (`tags`, `test`) — no datastore lookups participate in the branch decision, so datastore failure cannot disable isolation.

## 3. Three-Event Idempotency Replay Protocol

Inject the SAME real-shaped Suricata alert three times via test webhook:

| Replay | Expected |
|---|---|
| 1st | Routes: counter `routed` 0→1; exactly one IRIS `[P38TEST]` alert created |
| 2nd (same sid+src+dst within 60s bucket) | Deduped: counter `deduped` +1; NO second IRIS alert |
| 3rd (same key, new time bucket OR different src/dst) | Routes again: exactly one more IRIS alert |

Verification data source: per-execution `results[]` from
`GET /api/v1/workflows/<id>/executions` — count nodes labeled `iris-alert-P38TEST-internal-only`
with SUCCESS across the three executions must equal **2** (replays 1 and 3).

## 4. Synthetic Isolation Test Cases

| Case | Payload | Expected terminal node |
|---|---|---|
| S1 | Valid EVE + `"tags":["synthetic"]` | SINK-synthetic-logonly |
| S2 | Valid EVE + `"test":true`, no tags | SINK |
| S3 | Malformed JSON + tag string embedded raw | DEADLETTER-malformed (validation precedes; still never routes) |
| S4 | Valid EVE, no tag | Normal pipeline (control case) |

## 5. Counter Behavior Expectations

- Counters are keyed in workflow state (`p38_counter_*`); values monotonic within a state-retention window.
- Replays above must yield exact deltas: routed +2, deduped +1 over the three-event run.
- Counter increments must be atomic per execution (no double-count on retry of a failed node).
- Reset procedure before each proof round: clear keys via Tools `set_state` with empty value or fresh webhook path segment.

## 6. Malformed Rejection Samples

```json
{"eve": "not-json"}                                  → DEADLETTER-malformed (parse fail)
{"alert": {"signature_id": "ABC"}}                   → DEADLETTER-malformed (sid regex)
{"alert": {"signature_id": "2027967"}, "src_ip": ""} → DEADLETTER-malformed (empty src)
{}                                                   → DEADLETTER-malformed (all required missing)
```

Each rejection must produce a `P38DL MALFORMED` dead-letter line and zero IRIS nodes executed.

## 7. Datastore-Failure Simulation

Do NOT stop the Shuffle backend (would invalidate the whole environment). Instead simulate
unreachable TARGET and degraded STATE separately:

| Simulation | Method | Expected |
|---|---|---|
| Target unreachable | Temporarily rename the IRIS nginx alias used by the HTTP action OR point action at `127.0.0.1:9` (closed port) in a TEST copy of the workflow | Execution FINISHED-with-failed-node → DEADLETTER-targetfail; no retry storm; counters show routed NOT incremented (increment happens only after success branch wiring) |
| State store unreachable | Not directly injectable; assert instead that isolation (A4) holds without state reads, and document residual risk | Documented assertion only |

Observed precedent already on record: the existing high-severity workflow shows the
target-unreachable behavior live — `NameResolutionError ... 'iriswebapp_nginx'` inside otherwise
FINISHED executions (phase38-74 §4). That is the exact failure shape expected here.

## 8. Recovery Steps After Failed Proof

1. Fix workflow definition (import corrected JSON from phase38-75 §5 backup flow).
2. Clear counters and dedup state.
3. Re-run full protocol from §3 (no partial credit between rounds).
4. Record execution IDs of every proof run in the successor report.

## 9. Exit Criteria

Proof PASSES when: idempotency table §3 exact-match, all S-cases terminate at SINK/dead-letter,
counter deltas exact, malformed set fully rejected, target-failure lands in dead-letter, and the
execution graphs demonstrate A1–A4. Only then may phase38-77 reconsider production enablement.
