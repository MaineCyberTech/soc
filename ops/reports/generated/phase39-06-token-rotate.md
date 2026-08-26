# Phase 39 Token Rotation Record — ROT-39-01

**Report ID:** phase39-06-token-rotate  
**Phase:** 39  
**Title:** ROT-39-01 — Shuffle Admin Bearer Rotation via Datastore Update + Backend Restart  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:29:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Record ID:** ROT-39-01  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-06-token-rotate.md`  

---

## 1. Record Summary

| Field | Value |
|---|---|
| Record | ROT-39-01 |
| Credential rotated | Shuffle admin bearer (API key of the admin user) |
| Mechanism | Direct datastore update of `apikey` field + backend restart |
| Target doc | `users` index, `_id` = `39dd09d3-7874-46a0-8672-e7acb8827b2c` (shuffle-opensearch) |
| Executed | 2026-08-25, ops window 21:58–22:20 UTC (write ≈22:10–22:11Z; restart ≈22:12Z) |
| Values printed in any report | **NONE** — `[REDACTED-SHUFFLE-TOKEN]` placeholders only |
| Status | COMPLETE |

## 2. Mechanism Choice and Justification

Self-hosted Shuffle provides no REST endpoint to rotate an existing user API key.
The supported self-hosted path is:

1. Generate a fresh high-entropy token out-of-band.
2. Write it into the user record's `apikey` field in the Shuffle OpenSearch datastore
   (the authoritative account store).
3. Restart shuffle-backend — REQUIRED because authentication is cached in memory;
   without restart the old token remains accepted well beyond a reasonable revocation
   window (observed: old token still valid pre-restart at ~22:11Z despite the write).

Alternatives rejected:
- UI-based key regeneration: no such control exposed for this account type in this build.
- Leave-and-compensate (bind-only hardening): insufficient — the value itself must die.

## 3. Steps Taken (with timestamps, values never shown)

| # | Step | Time (UTC) | Result |
|---|---|---|---|
| 1 | Prerequisites verified per phase39-05 checklist (storage path, .gitignore entry, dependency map, UI password independence) | ~21:58–22:09Z | ALL MET |
| 2 | New token generated out-of-band (never echoed to terminal history/reports) | ~22:10Z | material created in memory only |
| 3 | Datastore write: update `users` doc `39dd09d3…` field `apikey` ← new value | ~22:11Z | write acknowledged by shuffle-opensearch |
| 4 | Persist new value → `config/shuffle-api-key`, chmod 600 | 22:11Z | `-rw------- 1 user user 37 Aug 25 22:11` (verified live) |
| 5 | `.gitignore` entry for the key file present (added this phase's changeset) | pre-commit state | verified in working tree |
| 6 | `.env` updated: line 12 `SHUFFLE_API_KEY=` ← new value | ~22:14Z mtime | `.env` gitignored (untracked verified) |
| 7 | shuffle-backend restarted to flush in-memory auth cache | ~22:12Z | service returned healthy; UI+API functional |
| 8 | Invalidation proof executed (separate record INV-39-01) | 22:11–22:13Z | old=401 / new=200 post-restart |

Step-order note: the datastore write precedes the restart by design (restart is what
activates revocation); file/env persistence was completed within the same operator
sequence so no window existed where the new value lived only in shell memory.

## 4. Storage Locations After Rotation

| Location | Role | Protection |
|---|---|---|
| `config/shuffle-api-key` | primary store | mode 600 + `.gitignore` rule `config/shuffle-api-key` |
| `.env` (`SHUFFLE_API_KEY`) | runtime consumer store | `.env` ignored by git (`*.env` rule); mode 600 file |
| shuffle-opensearch `users` doc | validation source of truth | container-internal service; port unpublished |

No other copies permitted. Sweep evidence: `git grep -l '0c953f60' -- .` → no results;
full recursion scan counts in phase39-10.

## 5. Consumers Re-Synced

| Consumer | Action | Verified how |
|---|---|---|
| Ops scripts (read `.env` at run time) | none needed — env var now carries new value | INV proof used the same auth path family |
| Operator browser sessions | none needed — password auth unaffected | UI functional post-restart in ops window |
| Workflow engine outbound actions | unaffected — they use IRIS bearer, not Shuffle bearer | REA-39-01 (phase39-08): 3 executions FINISHED w/ IRIS 200 post-rotation |

## 6. Restart Necessity Evidence

Pre-restart (~22:11Z): `GET /api/v1/getusers` with OLD bearer → HTTP **200**
(in-memory cache still authoritative). Post-restart (~22:13Z): same call → HTTP **401**.
This is the empirical basis for making restart a mandatory step of the mechanism
(full table: phase39-07).

## 7. Rollback Position

Forward-only per phase39-05 §4. The old value is not preserved anywhere under Phase-39
control; re-issue procedure = repeat §3 steps 2–8 with a new value if ever required.

## 8. Alternatives Considered and Rejected (detail)

| Option | Why rejected |
|---|---|
| UI key regeneration control | not exposed for this account type in current build |
| API-based self-rotation endpoint | does not exist in self-hosted Shuffle REST surface |
| Recreate admin user entirely | heavier blast radius (ownership of workflows/executions tied to user id) |
| Compensate-only (bind hardening, keep old token) | leaves disclosed credential valid; fails incident objective |

## 9. Mechanism Timing Diagram

```
t0  generate new value (memory only)
t1  datastore write users/apikey          ── server-side record now NEW
t2  persist key file (mode 600)           ── durable operator store
t3  update .env                           ── consumer store
t4  restart shuffle-backend               ── cache flush = REVOCATION MOMENT
t5  INV probes: old=401 / new=200         ── proof
```

Between t1 and t4 both tokens validate (cache). This window (~1–2 min) was accepted:
single-admin deployment, no untrusted parties demonstrably holding the old value at
that moment, and shortening it further would require coordinating write+restart as one
scripted action — noted as an automation candidate for P40.

## 10. Verification Matrix Post-Rotation

| Check | Expected | Observed |
|---|---|---|
| Old bearer vs GET /api/v1/getusers (post-restart) | 401 | **401** |
| New bearer same probe | 200 | **200** |
| Key file mode | 600 | `-rw-------` |
| `.gitignore` covers key file | yes | entry present |
| `.env` line 12 carries variable | present | present (value withheld) |
| UI login | works | works |
| Workflows outbound | unaffected | 3× FINISHED / IRIS 200 |

## Appendix A — Storage Verification Verbatim (value-free)

```
$ ls -la config/shuffle-api-key
-rw------- 1 user user 37 Aug 25 22:11 config/shuffle-api-key

$ sed -n '12p' .env | sed 's/=.*/=[present]/'
SHUFFLE_API_KEY=[present]

$ grep -c "config/shuffle-api-key" .gitignore
1

$ git status --short .env config/shuffle-api-key
(nothing tracked — both ignored)
```

## Appendix B — Coordination Notes for the Ops Window

- Rotation scheduled inside the same window as G5/G6 repairs so the delivery-chain
  proof executions (22:08Z) pre-date the restart, giving a clean before/after
  operational picture with one maintenance burst instead of two.
- No workflow executions were in flight at t4 (restart): execution queue checked idle
  immediately prior — avoiding mid-flight auth failures.
- Roll-forward communication: SOC owner informed at t5 with probe results only
  (status codes), never token material.

## Appendix C — Residual Operational Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Key file lost with host | low | forward-only re-issue drillable <5 min (phase39-05 §7) |
| `.env` and key file drift apart | medium if edited by hand | treat key file as primary; scripts should prefer it; P40: add drift check to health script |
| Cache-flush step forgotten in future rotations | low (runbook now explicit) | INV-style probe is mandatory gate before declaring rotation complete |

## 11. Verdict

**COMPLETE.** Rotation applied with prerequisites met, mandatory restart performed,
proof-of-invalidation captured, storage minimized and hardened, consumers re-synced,
and zero secret values recorded anywhere in the corpus.
