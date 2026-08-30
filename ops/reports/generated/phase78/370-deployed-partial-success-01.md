Report ID: 370-deployed-partial-success-01
Phase: 78
Title: Phase 78 eo — Deployed Partial-Success Fault
Date: 2026-08-30
Timestamp: 2026-08-30T00:00:00Z / 2026-08-29T20:00:00-04:00 (America/New_York)
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p78/prompts/370-deployed-partial-success-01.md
Prompt: deployed-partial-success

## Verdict
PASS. Through deployed Shuffle workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b, a partial-success fault (IRIS accepted, then ledger/dedup
write failed) yielded exactly ONE IRIS object (alert 620) with status
RECONCILIATION_REQUIRED; no duplicate was created on any replay.

## Evidence
- Identity P78-PARTIAL-01 executed with fault=partial via the deployed node.
- IRIS POST succeeded (alert 620); dedup ledger left in RECONCILIATION_REQUIRED
  (alert_id NOT recorded, fail-closed). direct_readback GET -> {'status': 200, 'source_ref': 'P78-PARTIAL-01'}.
- Replay of the same identity returns RECONCILE_PENDING/DUP_SKIP and creates NO second IRIS object.
- destination_object_count = 1.
Evidence file: /opt/mct-security-stack/ops/reports/evidence/phase78/phase78-evidence-eo.json

## Action
Fault injected in the deployed node's test-variant code; no second IRIS object observed.

## Backup-Rollback
Original node code restored (sha-verified); node `environment` = "Shuffle", no creds persisted.

## Stop-Conditions
None. Single-object guarantee held under partial-success.

## Limitations
OpenSearch reached via cert-valid hostname resolved to reachable container IP; dedup creds from dedicated
secret mount, not written to workflow config.
