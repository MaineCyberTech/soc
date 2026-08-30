Report ID: 360-fault-matrix-01
Phase: 78
Title: Phase 78 eo Fault Matrix — Deployed Shuffle
Date: 2026-08-30
Timestamp: 2026-08-30T00:00:00Z / 2026-08-29T20:00:00-04:00 (America/New_York)
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p78/prompts/360-fault-matrix-01.md
Prompt: fault-matrix

## Verdict
PASS. The complete effectively-once fault matrix was executed through the DEPLOYED Shuffle workflow
`c6b3fcd8-13e5-44a8-a818-024e4ae4422b` (wazuh-high-severity-to-iris), execute_python node id 484d8d7c-cd18-45d3-88d3-d337447ff670 — NOT a
host-side substitute. Across the entire fault window for the tested identity (P78-WINDOW-01) exactly ONE
IRIS object (alert 625) was created; all faults, replays, and races were blocked from creating a second.

## Evidence
- deployed_shuffle_test: true — executed via Shuffle execution API against workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b.
- stable_source_id: same id twice -> DUP_SKIP, cached alert_id 616 (parity OK).
- create_only: 2nd claim returns 409 (op_type=create), not overwrite; alert 617.
- occ: create-only protects the ledger; replay claim 409, no mutation; alert 618.
- delivered_immutable: DELIVERED record never mutated; replay DUP_SKIP alert 619.
- partial_success: state RECONCILIATION_REQUIRED, IRIS alert 620, exactly 1 object.
- crash_after_accept: state RECONCILE_CRASH, IRIS alert 621, exactly 1 object.
- response_loss: state RECONCILE_RESPONSE_LOSS, IRIS alert 622, exactly 1 object.
- timeout_ambiguity: state RECONCILIATION_REQUIRED, IRIS alert 623, exactly 1 object.
- reconciliation_blocks_replay: replay after RECONCILIATION_REQUIRED -> RECONCILE_PENDING, no new object.
- race_campaign: 10 concurrent identical executions -> 1 IRIS object
  (states: ['DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP', 'ROUTED', 'DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP', 'DUP_SKIP']); winner alert [624].
- direct_readback: IRIS API GET for alert 616 -> {'status': 200, 'source_ref': 'P78-STABLE-01'}.
- destination_object_count = 1 (per-identity; no tested identity produced more than one IRIS object).
Evidence file: /opt/mct-security-stack/ops/reports/evidence/phase78/phase78-evidence-eo.json

## Action
Deployed a test variant of the v2 atomic-dedup code to the live execute_python node, exercised every
fault (crash/response-loss/timeout/partial), replay, and a 10-way race through the deployed workflow,
then restored the original node code (sha-verified) and removed node configuration.

## Backup-Rollback
Original node code backed up at /tmp/opencode/orig_code.py (sha256 9d9db084...). Workflow node restored
to original via PUT; verified sha matches backup and `environment` field = "Shuffle" (no credentials
persisted in node config).

## Stop-Conditions
None triggered. All scenarios produced the expected single-object outcome; no duplicate IRIS objects.

## Limitations
The OpenSearch published 9200 is firewalled from the execution sandbox, so the test variant resolves the
cert-valid hostname `shuffle-opensearch` to the reachable container IP 172.20.0.3 (TLS verification
preserved). Dedup credentials are supplied from the dedicated secret `dedup-shuffle-dedicated` mounted
into the execution sandbox (read by the v2 code via load_env/os.environ) — no credentials were written
into the deployed workflow configuration.
