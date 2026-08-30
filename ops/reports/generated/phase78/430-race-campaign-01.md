Report ID: 430-race-campaign-01
Phase: 78
Title: Phase 78 eo — Race Campaign (10-way Concurrent)
Date: 2026-08-30
Timestamp: 2026-08-30T00:00:00Z / 2026-08-29T20:00:00-04:00 (America/New_York)
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p78/prompts/430-race-campaign-01.md
Prompt: race-campaign

## Verdict
PASS. Through deployed Shuffle workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b, a 10-way concurrent identical campaign on identity
P78-RACE-01 produced exactly ONE IRIS object (alert [624]); the other nine executions
returned DUP_SKIP/RECONCILE_PENDING.

## Evidence
- 10 concurrent executions of identity P78-RACE-01 via the deployed node.
- Result states: ['DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP', 'ROUTED', 'DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP'].
- unique IRIS objects created: 1; winner alert [624].
- dedup doc state DELIVERED; direct_readback GET -> {'status': 200, 'source_ref': 'P78-RACE-01'}.
- destination_object_count = 1.
Evidence file: /opt/mct-security-stack/ops/reports/evidence/phase78/phase78-evidence-eo.json

## Action
Race campaign fired through the deployed node; atomic claim (op_type=create) guaranteed single delivery.

## Backup-Rollback
Original node code restored (sha-verified); node `environment` = "Shuffle", no creds persisted.

## Stop-Conditions
None. Exactly one IRIS object under concurrency.

## Limitations
OpenSearch reached via cert-valid hostname resolved to reachable container IP; dedup creds from dedicated
secret mount, not written to workflow config.
