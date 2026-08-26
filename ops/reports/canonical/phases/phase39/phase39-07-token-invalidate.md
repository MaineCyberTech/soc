# Phase 39 Token Invalidation Proof — INV-39-01

**Report ID:** phase39-07-token-invalidate  
**Phase:** 39  
**Title:** INV-39-01 — Empirical Proof That the Old Shuffle Admin Bearer Is Rejected Post-Restart  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:30:00Z  
**Classification:** INTERNAL  
**Status:** PASS  
**Record ID:** INV-39-01  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-07-token-invalidate.md`  

---

## 1. Claim Under Test

> After ROT-39-01 (datastore `apikey` write + backend restart), the previously disclosed
> Shuffle admin bearer is no longer accepted by the Shuffle API, and the newly issued
> bearer is accepted.

## 2. Method

Single deterministic probe, chosen because it requires only read scope and its status
code is unambiguous:

```
GET /api/v1/getusers
Authorization: Bearer <candidate-token>
→ observe HTTP status code only; response bodies discarded (contain user metadata).
```

Probes executed with curl against the backend API path exposed at
`127.0.0.1:5001` (host-local). Candidate tokens supplied from operator-held material;
values never entered any log or report. Status codes captured verbatim.

## 3. Results Table

| # | Phase of test | Bearer used | Backend state | HTTP result | Meaning | Time (UTC) |
|---|---|---|---|---|---|---|
| 1 | Baseline sanity (pre-window behavior known-good) | old `[REDACTED-SHUFFLE-TOKEN]` | running, pre-write cache | **200** | old token valid before rotation — establishes the test discriminates | pre-22:10Z |
| 2 | Post-datastore-write, PRE-restart | old `[REDACTED-SHUFFLE-TOKEN]` | running, cache NOT flushed | **200** | in-memory auth cache still honors old token → restart is mandatory for revocation | ~22:11Z |
| 3 | Backend restart executed | — | restarted ~22:12Z | service healthy after return | cache flush boundary | ~22:12Z |
| 4 | POST-restart revocation check | old `[REDACTED-SHUFFLE-TOKEN]` | restarted | **401 INVALIDATED** | disclosed credential is dead server-side | ~22:13Z |
| 5 | POST-restart acceptance check | new `[REDACTED-SHUFFLE-TOKEN]` | restarted | **200 VALID** | replacement token authoritative | ~22:13Z |

Rows 2→4 form the proof pair: identical request, identical token, only variable changed
is the restart. The 200→401 transition isolates revocation to the intended mechanism.

## 4. Why Row 2 Matters (recorded honestly)

Without row 2, a future operator could assume the datastore write alone revokes access.
It does not — the cache honored the old token until restart. This observation is now a
standing rule in the rotation runbook lineage: **datastore write + restart are one
atomic operation conceptually; never declare rotation complete between them.**

## 5. Corroborating Signals (same window)

- UI login (password-based) functional post-restart — operator not locked out.
- Workflow executions continued to FINISH post-rotation (they authenticate outbound to
  IRIS, unaffected by this rotation — see REA-39-01), demonstrating no collateral
  breakage inside the engine during the restart window.
- Frontend reachability checks (mgmt 200 / loopback refused) re-confirmed after the
  recreate+restart sequence, i.e., hardening G3 survived the restart.

## 6. Scope and Limitations

- Probe covers bearer-authenticated REST paths as a class via one representative
  endpoint; per-endpoint ACL differences are out of scope (single admin account model).
- Status codes only; no timing analysis of cache TTL performed beyond the observed
  >95s persistence implied by row 2's timing.
- Test executed once in the ops window by the operator; this report records that
  execution rather than re-driving authenticated calls (avoiding further handling of
  secret material in report production).

## 8. Probe Command Shape (redacted form)

```
# representative probe (values substituted at execution time, never logged)
curl -s -o /dev/null -w "%{http_code}" \
     -H "Authorization: Bearer [REDACTED-SHUFFLE-TOKEN]" \
     http://127.0.0.1:5001/api/v1/getusers
```

Only the `%{http_code}` output was captured into ops notes; response bodies (user
metadata) were discarded at execution time to avoid creating new value-adjacent
artifacts.

## 9. Interpretation Rules Recorded for Future INV Records

| Observation | Correct interpretation |
|---|---|
| old=200 after datastore write | cache not flushed — rotation NOT complete |
| old=401 post-restart | revocation achieved |
| new=401 post-restart | write hit wrong doc/field or restart cleared to stale index — STOP, re-verify doc id before further attempts |
| both 401 | total auth outage — check datastore health first, then restore new token via §4.2 forward-only path |

## 10. Re-Run Procedure (if ever required)

1. Confirm backend uptime > 0 and datastore reachable.
2. Execute probe with current sanctioned-store token → expect 200 (canary).
3. If testing a suspect-leaked candidate: execute same probe → 401 proves invalidity.
4. Append results row to this table lineage with timestamp; never log tokens.

## Appendix A — Test Design Rationale

`GET /api/v1/getusers` was selected over alternatives because:

| Candidate probe | Rejected/selected | Reason |
|---|---|---|
| GET /api/v1/getusers | SELECTED | read-only; 200/401 unambiguous; exercises the exact bearer path class |
| Workflow list endpoint | rejected | larger response surface (unneeded data handling) |
| Any POST/mutation probe | rejected | proof must never mutate state |
| UI login simulation | rejected | tests password path, not bearer path |

## Appendix B — Observed Cache Behavior Detail

The pre-restart acceptance (row 2) persisted across multiple probes spanning >95s,
establishing the cache TTL lower bound empirically. Practical consequence already
encoded in the runbook: the datastore write and the restart must be treated as one
logical operation with zero operator delay between them in future rotations
(automation candidate noted in phase39-06 §9).

## Appendix C — What Would Falsify This Proof

Honest falsification criteria, for future auditors:

1. A successful authenticated API action using the OLD bearer after ~22:13Z would
   invalidate INV-39-01. None observed through end of ops window.
2. Evidence that the backend restart did not occur (container uptime continuous) would
   void rows 3–5. Container restart verified via compose state + healthy-return.
3. Discovery of a second auth cache layer (e.g., frontend proxy cache) could narrow the
   proof's scope to backend-only. No such layer found in this deployment topology.

## Appendix D — Post-Rotation Stability Watch

Through report-production time (~22:35Z), repeated operational API usage (catalog
writes, workflow reads by ops scripts) continued against the NEW token with no 401
events — an informal soak of ~20 minutes beyond the formal proof window.

## Appendix E — Proof Chain Cross-References

This INV record does not stand alone; its claim is anchored by four sibling records:

| Sibling | Contribution to the chain |
|---|---|
| ROT-39-01 (phase39-06) | the rotation mechanism and restart step being proven |
| REA-39-01 (phase39-08) | no collateral damage from the restart window |
| INC-39-01 (phase39-03) | why the old token had to die (disclosure classification) |
| phase39-05 | why no rollback to the old token exists or may exist |

An auditor can reconstruct the full credential lifecycle — disclosure, decision,
rotation, revocation proof, forward-only policy — from these five documents without
ever encountering a secret value.

## 11. Verdict

**PASS.** Old bearer INVALIDATED (HTTP 401 post-restart); new bearer VALID (HTTP 200);
revocation boundary proven to be the restart; zero secret values recorded.
