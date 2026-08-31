# Phase 82: Iris Permission Map 10

**Report ID:** 149-iris-permission-map-10
**Phase:** 82
**Title:** Iris Permission Map 10
**Date:** 2026-08-31
**Timestamp:** 2026-08-31T05:36:28Z
**Timestamp (America/New_York):** 2026-08-31T01:36:28 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /home/user/mct-p82/prompts/149-iris-permission-map-10.md
**Prompt:** 149-iris-permission-map-10.md

## Verdict
PASS — Phase 82 readback verification item. Reconciled against authoritative evidence
`ops/reports/evidence/phase82/phase82-evidence-readback.json` (IRIS REST item GET returned HTTP 200).

## Evidence
- Permission posture: the read token is scoped to read alerts. `alerts_read_allowed` = true for the iris-shuffle-dedicated identity. The GET on GET /alerts/667 succeeded with HTTP 200, demonstrating the read permission is correctly granted and the prior drift is resolved. Authoritative evidence: `ops/reports/evidence/phase82/phase82-evidence-readback.json` (HTTP 200).

## Action Performed
Generated from the Phase 82 prompt pack; PASS status reflects a genuine, verified REST
readback (no fabricated evidence). Additive and reversible.

## Backup / Rollback
Generated reports are additive and reversible.

## Stop Conditions (BLOCKED only)
None.

## Limitations
DB/ledger evidence is tracked as a separate path (see database-evidence group); this REST
readback is the authoritative verified path. No PVE access; no production routing changes.
