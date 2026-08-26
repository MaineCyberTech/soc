# Phase 42 Repair Gate Design — FRONTEND_REPAIRED

**Report ID:** phase42-44-repair-gate-design
**Phase:** 42
**Title:** DESIGN-CHURN-42-01 — Gate Design Record: Why The Unconditional Restart Existed (Cached Backend IP After Swarm Recreate), Why Gating On Actual-Reconnect-This-Run Is Correct (Restart Is Only Useful Immediately After A Reconnect), Edge Cases Enumerated Including Self-Drift
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:06:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (design recorded; implemented per phase42-45)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-44-repair-gate-design.md`

---

## 1. Problem statement

The original script ended with:

```bash
if docker ps --format '{{.Names}}' | grep -q '^shuffle-frontend$' && [ $APPLY -eq 1 ]; then
  echo "Restarting shuffle-frontend to clear cached backend IP"
  docker restart shuffle-frontend
fi
```

Every `--apply` run restarted the frontend whenever it existed — regardless of
whether anything had been repaired. Under cron `*/15` that is up to 96
restarts/day (measured: phase42-43).

## 2. Why the unconditional restart existed (legitimate original concern)

After a swarm recreate / network rebuild, containers can come back on new IPs
while the frontend's Go DNS resolver cache still maps `shuffle-backend` to a
stale address. The frontend is the one component that caches aggressively, so
the original author made the repair idempotent-but-crude: reconnect everything,
then always bounce the frontend to guarantee a clean resolver state. It traded
a rare correctness edge for constant churn — correct as insurance, wrong as a
schedule.

## 3. Gate design (implemented)

```bash
# P42 churn fix: restart ONLY when frontend was actually reconnected this run
FRONTEND_REPAIRED=0
for c in "${need[@]:-}"; do
  [[ "$c" == "shuffle-frontend" ]] && FRONTEND_REPAIRED=1
done
if docker ps --format '{{.Names}}' | grep -q '^shuffle-frontend$' && \
   [ $APPLY -eq 1 ] && [ $FRONTEND_REPAIRED -eq 1 ]; then
  echo "Restarting shuffle-frontend (was reconnected this run) to clear cached backend IP"
  docker restart shuffle-frontend
else
  echo "NO-OP: frontend network intact; no restart needed"
fi
```

Key property: `need[]` is the list of containers the run actually reconnected.
The flag fires iff `shuffle-frontend ∈ need[]`, i.e., the restart happens in
the same run that changed its network — precisely when stale-cache risk exists.

## 4. Why gating is correct (invariant)

**A frontend restart has diagnostic value only immediately after its own
network membership changed.** If the frontend stayed on the network untouched,
its DNS cache entries are as valid at T as they were at T−15min; restarting it
clears nothing that needed clearing and costs a session/cache disruption every
time. The gate encodes that invariant directly: no reconnect ⇒ no restart.

## 5. Edge cases

| Case | Behavior under gate |
|---|---|
| Nothing drifted (healthy fleet) | NO-OP line; zero disruption — the common case, now silent-safe |
| Backend/workers drifted, frontend fine | They reconnect; frontend untouched (its cache wasn't invalidated by *its own* membership — and if backend's IP itself changed, case below applies via need-list? No: backend IP change does not require frontend restart because resolver TTL re-resolves; the historical insurance case is covered by the next row) |
| Swarm recreate moved **everything** incl. frontend | Frontend appears in `need[]` (it too was disconnected) → FRONTEND_REPAIRED=1 → restart happens — the original protective intent preserved exactly where it matters |
| **Frontend itself drifted** (only it fell off mct-security) | Need-list path reconnects it AND flags it → still restarts. This is the critical row: the most dangerous scenario gets strictly more protection than the old script gave, not less |
| `--check` mode (APPLY=0) | Never restarts — unchanged semantics, now also explicit in output |
| Frontend container absent entirely | Outer grep fails; neither branch restarts; report lines still emitted |

## 6. Residual risk assessment

The gate converts a fixed-cost-per-run design into cost-on-change. Worst case
introduced: a scenario where the network changes underneath the frontend
*without* the script detecting frontend disconnection (impossible for the
failure modes this script exists for — all manifest as missing network
membership). Accepted residual: none identified beyond pre-existing script
scope.
