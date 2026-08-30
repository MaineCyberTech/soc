Report ID: 380-deployed-crash-after-accept-01
Phase: 78
Title: Phase 78 eo — Deployed Crash-After-Accept Fault
Date: 2026-08-30
Timestamp: 2026-08-30T00:00:00Z / 2026-08-29T20:00:00-04:00 (America/New_York)
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p78/prompts/380-deployed-crash-after-accept-01.md
Prompt: deployed-crash-after-accept

## Verdict
PASS. Through deployed Shuffle workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b, a crash simulated immediately after IRIS accept produced
exactly ONE IRIS object (alert 621) with status RECONCILE_CRASH; replay is
fail-closed and creates no duplicate.

## Evidence
- Identity P78-CRASH-01 executed with fault=crash_after_accept via the deployed node.
- IRIS POST succeeded (alert 621); ledger finalize simulated-crashed; dedup left
  RECONCILE_CRASH with alert_id=None. direct_readback GET -> {'status': 200, 'source_ref': 'P78-CRASH-01'}.
- Replay -> RECONCILE_PENDING (claim_without_alert_id; no_duplicate).
- destination_object_count = 1.
Evidence file: /opt/mct-security-stack/ops/reports/evidence/phase78/phase78-evidence-eo.json

## Action
Crash point injected in deployed test variant; single object confirmed.

## Backup-Rollback
Original node code restored (sha-verified); node `environment` = "Shuffle", no creds persisted.

## Stop-Conditions
None. No second IRIS object under crash-after-accept.

## Limitations
OpenSearch reached via cert-valid hostname resolved to reachable container IP; dedup creds from dedicated
secret mount, not written to workflow config.
