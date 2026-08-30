Report ID: 420-replay-denial-01
Phase: 78
Title: Phase 78 eo — Replay Denial (Effectively-Once)
Date: 2026-08-30
Timestamp: 2026-08-30T00:00:00Z / 2026-08-29T20:00:00-04:00 (America/New_York)
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p78/prompts/420-replay-denial-01.md
Prompt: replay-denial

## Verdict
PASS. Through deployed Shuffle workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b, replay of a DELIVERED or RECONCILIATION_REQUIRED identity
is denied (DUP_SKIP / RECONCILE_PENDING) and never creates a duplicate IRIS object.

## Evidence
- stable_source_id: replay -> DUP_SKIP, same alert_id 616 (parity).
- create_only: replay -> DUP_SKIP (409, not overwrite).
- occ: replay -> DUP_SKIP (ledger protected).
- delivered_immutable: DELIVERED doc never mutated; replay -> DUP_SKIP, same
  alert_id 619.
- reconciliation_blocks_replay: replay -> RECONCILE_PENDING.
- All replays produced zero additional IRIS objects.
- destination_object_count = 1.
Evidence file: /opt/mct-security-stack/ops/reports/evidence/phase78/phase78-evidence-eo.json

## Action
Replay denial exercised across all identity states via the deployed node.

## Backup-Rollback
Original node code restored (sha-verified); node `environment` = "Shuffle", no creds persisted.

## Stop-Conditions
None. Replay always fail-closed.

## Limitations
Deterministic dedup doc id (event_id) + op_type=create is the guarantee; no duplicate IRIS POST occurs.
