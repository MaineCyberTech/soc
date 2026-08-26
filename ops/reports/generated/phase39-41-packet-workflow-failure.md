# Phase 39 Packet Workflow Failure Matrix — FAIL-39-02

**Report ID:** phase39-41-packet-workflow-failure  
**Phase:** 39  
**Title:** Fault-Injection Matrix for the Packet Lane (Malformed / Datastore-Down / Downstream-Unreachable / Auth-Fail) With Guardrail-Independence Assertion — BLOCKED-MATRIX-DEFINED  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** BLOCKED (workflow not yet on platform; matrix pre-committed)  
**Record ID:** FAIL-39-02  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-41-packet-workflow-failure.md`

---

## 1. Blocker

Same gate as REPLAY-39-02 (WF-39-02 API 401; UI import pending). Matrix is fixed now
so post-import testing is mechanical and unbiased.

## 2. Failure Matrix

| Case | Injection | Expected workflow behavior | Expected side effects |
|---|---|---|---|
| M1 malformed payload | POST body missing `src_ip` (or non-numeric sid) | `validate-required-fields` fails → `DEADLETTER-malformed`; execution FINISHED via dead-letter arm | **no IRIS call, no dedup key consumed**, counter untouched |
| M2 datastore down | pause/scale datastore backing state before event | `datastore-dedup-set` fails → run takes failed arm to dead-letter (`P39DL TARGETFAIL` family or explicit state-fail log) — never routes un-deduplicated | no IRIS alert; failure visible in execution record; ALERT-style monitoring would flag |
| M3 downstream unreachable | `docker network disconnect shuffle_swarm_executions iriswebapp_nginx` (known-good injection, proven in P39 layer-1 era) | HTTP action fails → try/catch failed arm → `DEADLETTER-target-fail`; run FINISHED-with-dead-letter | zero partial writes at IRIS; reconnect + re-run restores delivery (procedure NET-39-01-APPLY §6) |
| M4 auth fail | corrupt the headers parameter bearer (in test copy only) | IRIS returns 401-class → HTTP action failed arm → dead-letter | same as M3; demonstrates auth faults cannot silently drop |

Common acceptance rule for all cases: **the workflow must terminate in an
explicitly-recorded terminal branch — never hang, never route garbage, never emit a
partial alert.**

## 3. External-Guardrail Independence Assertion

> Dedup lives **inside the workflow's own datastore** (key
> `sid-src_ip-dst_ip-epoch300`, TTL 300 s). It does not depend on any external
> component — not on Wazuh, not on IRIS, not on network reachability of the target.
> Consequently: guardrails M1/M3/M4 outages change *where runs end* but cannot disable
> suppression semantics; conversely, restoring downstream access requires no dedup
> re-seeding.

This independence is what makes the lane safe to enable/disable repeatedly during
testing without contaminating production dedup state.

## 4. Execution Notes for Post-Import Run

- Run M-cases in order M1→M4 (least invasive first); restore state between cases.
- Capture per-case: execution id, terminal node label, IRIS psql row-count delta
  (must be 0 for M1–M4), datastore counter delta (must be 0).
- Record actual outcomes into the successor report; any deviation = FAIL verdict for
  ROUT-39-02 precondition.

## Verdict

**BLOCKED-MATRIX-DEFINED.** Unblocks with WF-39-02 import; expected behaviors are
pre-committed above and become pass/fail criteria verbatim.
