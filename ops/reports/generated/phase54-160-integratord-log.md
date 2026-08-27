# Phase 54: Integratord Evidence

**Prompt:** 160-integratord-log
**Generated (UTC):** 2026-08-27T21:29:08Z
**Operator (EDT):** 2026-08-27T17:29:08-0400
**Verdict:** DONE

## Summary
Read-only correlation of the Wazuh integratord's forwarding of high-severity alerts to the Shuffle
Class-A webhook. No packet was sent and no canary was executed — the Wazuh sensor-to-IRIS E2E
canary/APPLY-SEND is BLOCKED under the gate policy (see 166). This prompt captures the invocation
path and evidence only.

## Evidence
- E1 (run-context) — Wazuh master resolves shuffle-backend (172.20.0.6); Class-A forwarder POSTs to
  webhook_eb937a37 and receives HTTP 200. Internal http://shuffle-backend:5001 used, NOT shuffler.io.
- E2 (OpenSearch `hooks`) — Class-A trigger eb937a37-5244-46dc-95ff-62ad4c681322 (name
  `wazuh-high-severity`) running=True, type=webhook, status=running.
- E3 (OpenSearch `workflowexecution`) — Class-A workflow eb937a37 executed 88 times, all status
  FINISHED (no failure burst observed in sampled window).

## Backup / Rollback
N/A — read-only analysis. No config or data mutated.

## Stop conditions (BLOCKED only)
N/A.

## Limitations
The actual integratord log file on the Wazuh master was not fetched (cross-host, read-only bound to
Shuffle-side evidence). The live canary send remains BLOCKED pending signed production approval.

## Verdict rationale
Invocations path, hook liveness, and execution health are confirmed read-only; no mutating action
taken. Canary send is separately BLOCKED (prompt 166).
