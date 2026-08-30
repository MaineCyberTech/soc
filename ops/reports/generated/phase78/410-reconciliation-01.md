Report ID: 410-reconciliation-01
Phase: 78
Title: Phase 78 eo — Reconciliation Blocks Replay
Date: 2026-08-30
Timestamp: 2026-08-30T00:00:00Z / 2026-08-29T20:00:00-04:00 (America/New_York)
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p78/prompts/410-reconciliation-01.md
Prompt: reconciliation

## Verdict
PASS. Through deployed Shuffle workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b, once an identity is in RECONCILIATION_REQUIRED (or DELIVERED),
any automated replay is blocked from creating a second IRIS object.

## Evidence
- timeout scenario (P78-TIMEOUT-01, alert 623) left dedup state
  RECONCILIATION_REQUIRED. Replay of the same identity returned RECONCILE_PENDING
  (claim_without_alert_id / DUP_SKIP) and created NO new IRIS object.
- crash/partial/response-loss scenarios likewise enter reconcile states and block replay.
- fault-window single identity (P78-WINDOW-01) exercised happy+crash+loss+timeout+partial+replay+race
  -> exactly 1 IRIS object(s).
- destination_object_count = 1.
Evidence file: /opt/mct-security-stack/ops/reports/evidence/phase78/phase78-evidence-eo.json

## Action
Reconciliation path exercised via the deployed node; replay denial confirmed.

## Backup-Rollback
Original node code restored (sha-verified); node `environment` = "Shuffle", no creds persisted.

## Stop-Conditions
None. Reconciliation correctly blocks automated retry/replay.

## Limitations
Reconciliation is manual-resolve by design (fail-closed); no second POST is ever attempted.
