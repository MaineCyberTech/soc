Report ID: 400-deployed-timeout-01
Phase: 78
Title: Phase 78 eo — Deployed Timeout/Ambiguity Fault
Date: 2026-08-30
Timestamp: 2026-08-30T00:00:00Z / 2026-08-29T20:00:00-04:00 (America/New_York)
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p78/prompts/400-deployed-timeout-01.md
Prompt: deployed-timeout

## Verdict
PASS. Through deployed Shuffle workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b, an ambiguous timeout produced exactly ONE IRIS object
(alert 623) with status RECONCILIATION_REQUIRED; uncertainty entered reconciliation
rather than creating a duplicate.

## Evidence
- Identity P78-TIMEOUT-01 executed with fault=timeout via the deployed node.
- IRIS POST succeeded (alert 623); ambiguous timeout -> RECONCILIATION_REQUIRED
  (alert_id not finalized). direct_readback GET -> {'status': 200, 'source_ref': 'P78-TIMEOUT-01'}.
- Replay -> RECONCILE_PENDING (reconciliation_blocks_replay: blocked).
- destination_object_count = 1.
Evidence file: /opt/mct-security-stack/ops/reports/evidence/phase78/phase78-evidence-eo.json

## Action
Timeout/ambiguity injected in deployed test variant; single object + reconciliation confirmed.

## Backup-Rollback
Original node code restored (sha-verified); node `environment` = "Shuffle", no creds persisted.

## Stop-Conditions
None. Reconciliation entered; no duplicate.

## Limitations
OpenSearch reached via cert-valid hostname resolved to reachable container IP; dedup creds from dedicated
secret mount, not written to workflow config.
