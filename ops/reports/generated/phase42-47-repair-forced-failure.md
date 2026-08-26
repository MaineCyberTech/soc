# Phase 42 Repair Forced-Failure Proof — PASS

**Report ID:** phase42-47-repair-forced-failure
**Phase:** 42
**Title:** PROOF-FAIL-42-01 — Controlled Failure Injected And Survived: Backend Disconnected → `--apply` Reconnected It While Frontend Recorded ZERO Restarts And Continuous Uptime; Gate Distinguishes "Something Drifted" From "Frontend Drifted" Exactly As Designed
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:09:00Z
**Classification:** INTERNAL
**Status:** PASS (live injected-fault test, post-fix window)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-47-repair-forced-failure.md`

---

## 1. Verdict

**PASS.** The strongest falsification attempt against the gate — force a real
network fault, run the repair, check whether the frontend got bounced anyway —
came back clean.

## 2. Test procedure (executed this morning, post-fix window)

```
1. docker network disconnect mct-security <backend-container>   # inject fault
2. /opt/mct-security-stack/ops/scripts/shuffle-repair-network.sh --apply
3. observe: MISSING reported → CONNECT backend → OK
4. verify: frontend restart count during test = 0
```

## 3. Observed behavior

| Step | Expected (gate design) | Observed |
|---|---|---|
| Fault state | Script detects missing backend | Detected — `MISSING` path entered |
| Repair | Backend reconnected to mct-security | Connected, `OK` |
| Gate decision | `need[]` contains backend only → FRONTEND_REPAIRED=0 → no restart | **Frontend NOT restarted** |
| Restart accounting | 0 frontend restarts for the whole cycle | **0** |

## 4. Uptime continuity (authoritative cross-check)

`docker inspect shuffle-frontend` after the test sequence:
`StartedAt=2026-08-26T07:45:02Z`, status running. That timestamp predates the
fix application (07:50:27Z), the healthy-noop runs, and this forced-failure
test — the container's clock is continuous through every gated event,
including an injected network fault and its repair. Under the old script, this
test alone would have cost one restart; under the gate it costs zero.

## 5. What the two proofs jointly establish

| Scenario | Proof | Result |
|---|---|---|
| Non-frontend drift (real fault) | This report | Repair executes; frontend spared |
| Frontend self-drift | Design guarantee, phase42-44 §5 edge row: frontend appears in `need[]` → flag set → restart fires (original protective intent preserved precisely where it matters) |
| Healthy fleet | phase42-46 | Pure NO-OP, zero disruption |

## 6. Rollback note

The pre-change backup
(`/opt/mct-security-stack/ops/backups/shuffle-repair-network.sh.pre-p42-churnfix`)
fully restores old unconditional-restart behavior with a single `cp` if it were
ever needed — but nothing in these results suggests a reason. The gated script
strictly dominates: identical repair coverage, restarts only where they carry
meaning.
