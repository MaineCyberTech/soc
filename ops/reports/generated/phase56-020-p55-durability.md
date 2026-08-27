# Phase 56: P55 Durability Scope

**Prompt:** 020-p55-durability
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27 20:30:00 -0400
**Verdict:** PARTIAL

## Summary
Inspected durability of the Phase 54 service-scoped Swarm secret `iris-shuffle-env` against the current running service, with analysis of cross-recreation (Orborus swap, host reboot, manager restart, full restore) scenarios. Current-service durability is VERIFIED; recreate/restore scenarios are approval-gated and were not exercised.

## Evidence
- EV-SEC-001 (VERIFIED): `docker secret inspect iris-shuffle-env` → ID `4vpfvc92ice01x52qtc69yi2c`, mode implied 0444, granted to EXACTLY `shuffle-tools_1-2-0` (negative scan of all swarm services confirms no other grant). Mirrors Phase 55 VERIFIED carryover.
- EV-CFG-001 (VERIFIED): `load_iris_token()` in `suricata-packet-routing` reads candidates `/run/secrets/iris-shuffle.env` (from this secret) and `/shuffle-files/iris-shuffle.env` (legacy fallback, DEFERRED removal). Token value never read/printed.
- EV-WF-002 (VERIFIED): `suricata-packet-routing` (`e133a645-…`) `active`, trigger `736b7410` running; IRIS ROUTED re-proven in Phase 55 (carryover EV-ROUTED-001).

## Backup-Rollback
No mutation performed (read-only). If a future recreation is authorized, take pre-change backup per `AGENTS.md` (`ops/backups/agents/`) and re-run the Phase 54 service-spec grant before any `shuffle-tools` recreation; legacy `/shuffle-files` bind retained as fallback until owner-approved removal (DEFERRED).

## Stop conditions
STOP at: Orborus replacement, host reboot, manager/service deletion, full restore (run-context §4/§6 — owner/approval gates 047-048, 302-305). Not crossed; inspection only.

## Limitations
Cross-recreation durability (Orborus swap, host reboot, full restore) is not exercised here — these are approval-gated and out of scope for a read-only pack. Only the *current* live grant is asserted.

## Verdict rationale
Current-service durability VERIFIED; recreate/restore scenarios legitimately deferred (gated). Marked PARTIAL rather than DONE because the prompt's durability scope spans gated recreations not observable in a read-only run.
