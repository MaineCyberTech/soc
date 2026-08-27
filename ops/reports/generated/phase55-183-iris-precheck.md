# Phase 55: IRIS Precheck (Object proof)

**Prompt:** 183-iris-precheck
**Generated (UTC):** 2026-08-27T23:04:29Z
**Operator (EDT):** 2026-08-27T19:04:29-0400
**Verdict:** PARTIAL

## Summary
Precheck of the IRIS token/secret delivery path used by the ROUTED workflow, plus the object-proof basis for IRIS alert creation. The Swarm secret and its fallback bind mount are both present and mounted in `shuffle-tools`. Object-content parity relies on the Phase 54 VERIFIED carryover and was not independently re-proven this run (a live re-route is production-gated).

## Evidence
- EV-183-1: Swarm secret `iris-shuffle-env` (ID `4vpfvc92ice01x52qtc69yi2c`, created 2026-08-27, mode 0444-equiv) is mounted in `shuffle-tools_1-2-0` at `/run/secrets/iris-shuffle.env` (78 bytes, `r--r--r--`). [VERIFIED]
- EV-183-2: Fallback bind `/shuffle-files` (host `data/shuffle/files`) presents `iris-shuffle.env` (78 bytes, mode 600, gitignored, sourced from `creds.env`). Present in container at `/shuffle-files/iris-shuffle.env`. [VERIFIED]
- EV-183-3: Phase 54 ROUTED re-proof: execution `2ce46d4a-b071-4331-b175-b40ee2b31692` FINISHED with `MCT_TEST_ID` present, routing to IRIS object id `67`. [VERIFIED — carryover, do not re-litigate per run-context §2]
- EV-183-4: Object-content parity not independently re-verified this run (would require a live re-route = production evidence; gated). [UNVERIFIED this run]

## Backup-Rollback
None (read-only). The secret is the durability artifact; rollback = remove service-scoped grant (orchestrator-only).

## Stop conditions
Live re-route to IRIS (object-content parity) is production-routing gated; not performed in this read-only run.

## Limitations
- IRIS object-content parity depends on Phase 54 VERIFIED carryover; not re-litigated.
- Token file values were never read or printed; referenced by path/ID only.

## Verdict rationale
Live token/secret delivery path (secret + fallback) VERIFIED. Object-content parity carried from P54 VERIFIED. Therefore PARTIAL: supporting path proven, object-content not independently re-proven this run.
