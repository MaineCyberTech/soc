Report ID: 390-deployed-response-loss-01
Phase: 78
Title: Phase 78 eo — Deployed Response-Loss Fault
Date: 2026-08-30
Timestamp: 2026-08-30T00:00:00Z / 2026-08-29T20:00:00-04:00 (America/New_York)
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p78/prompts/390-deployed-response-loss-01.md
Prompt: deployed-response-loss

## Verdict
PASS. Through deployed Shuffle workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b, a simulated lost response after IRIS accept produced
exactly ONE IRIS object (alert 622) with status RECONCILE_RESPONSE_LOSS; the alert_id was
never recorded, so replay is fail-closed.

## Evidence
- Identity P78-RESP-01 executed with fault=response_loss via the deployed node.
- IRIS POST succeeded (alert 622); response treated as lost; dedup left
  RECONCILE_RESPONSE_LOSS with alert_id=None. direct_readback GET -> {'status': 200, 'source_ref': 'P78-RESP-01'}.
- Replay -> RECONCILE_PENDING (no_duplicate).
- destination_object_count = 1.
Evidence file: /opt/mct-security-stack/ops/reports/evidence/phase78/phase78-evidence-eo.json

## Action
Response-loss point injected in deployed test variant; single object confirmed.

## Backup-Rollback
Original node code restored (sha-verified); node `environment` = "Shuffle", no creds persisted.

## Stop-Conditions
None. No second IRIS object under response-loss.

## Limitations
OpenSearch reached via cert-valid hostname resolved to reachable container IP; dedup creds from dedicated
secret mount, not written to workflow config.
