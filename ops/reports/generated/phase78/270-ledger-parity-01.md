# Ledger Parity — Create-Only / Dedup Behavior (Phase 78)

**Report ID:** phase78-ledger-parity-01
**Phase:** 78
**Title:** Ledger Parity — Create-Only / Dedup Behavior (Phase 78)
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T19:32:14Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T15:32:14 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /home/user/mct-p78/prompts/270-ledger-parity-01.md
**Prompt:** 270-ledger-parity-01.md

## Verdict
PASS — ledger_parity true: deterministic doc id yields 201 then 409 (DUP_SKIP); one destination object per event.

## Evidence
With dedup_writer (dedicated secret):
- PUT wazuh-iris-dedup-000001/_doc/led_e1?op_type=create -> 201.
- Repeat same id -> 409 (atomic create-only claim; second claim rejected, no overwrite).
- E2E canaries: each unique event_id produced exactly one IRIS alert (602, 603); no duplicate objects.
- v2 logic maps 409 -> DUP_SKIP (fail-closed, never re-POSTs).

## Action
Verified create-only ledger semantics and exactly-once destination objects.

## Backup-Rollback
Ledger rows created during test deleted by id post-verification.

## Stop-Conditions
Would STOP if second claim overwrote or produced a second IRIS object.

## Limitations
Live E2E dedup CLAIM persistence is blocked by app-container secret mount gap (documented); ledger correctness verified via direct scoped-user calls.
