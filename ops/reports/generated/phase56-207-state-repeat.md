# Phase 56: Repeatability

**Prompt:** 207-state-repeat
**Generated (UTC):** 2026-08-27T21:30:00Z
**Operator (EDT):** 2026-08-27T17:30:00-0400
**Verdict:** PARTIAL

## Summary
Read-only inspection confirms the state machine is deterministic for a given input (no randomness; pure function of payload + datastore state), supporting repeatability. A second *clean* run was not executed because a clean run that reaches ROUTED would create an IRIS object, forbidden this pack.

## Evidence
- EV-WF-2 (VERIFIED): `main()` is a deterministic function of the webhook payload + datastore reads; no time/random dependence except dead-letter keys (which use `time.time()` only for key naming, not state selection).
- EV-EXEC-1 (VERIFIED): 100 executions present, all `FINISHED`; carryover ROUTED execs `2ce46d4a` (→IRIS 67) and `19791f62` (→IRIS 68) demonstrate repeated successful ROUTED runs historically.
- EV-WF-3 (VERIFIED): dedup `check_cache_contains(append=True)` means a *repeat* of the same packet correctly yields `DUPLICATE` (idempotent), while a distinct packet routes — repeatability is by-design for distinct inputs.

## Backup / Rollback
N/A (read-only). A second clean run would be reversible only if synthetic + non-ROUTED.

## Stop conditions
IRIS object creation gate (run-context §5). A second clean ROUTED run deferred.

## Limitations
- Cannot demonstrate a fresh clean ROUTED run without creating an IRIS object.
- Repeatability of the *counter* under repeat is moot (counter is a flag — see 202).

## Verdict rationale
Determinism VERIFIED read-only; live second clean run gated. PARTIAL.
