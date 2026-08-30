# Current State — Phase 79 (canonical, live truth)

**Doc ID:** current-state-20260830-p79
**Phase:** 79
**Date:** 2026-08-30
**Timestamp (UTC):** 2026-08-30T23:20:00Z
**Classification:** INTERNAL
**Status:** ALL VALIDATORS PASS
**Supersedes:** current-state-20260830-p78 (carried authority; Phase 79 continues the same stack)

## Validator State (all PASS)

| Validator | Result |
|-----------|--------|
| p79-inventory | 790/790 unique, no missing, no duplicates |
| p79-time-anchor | in-window |
| p79-recreate-validate | all 14 keys true |
| p79-deployed-e2e-validate | all 15 keys true; request_executor = shuffle_action_task |
| p79-eo-validate | all 13 keys true; destination_object_count = 1 |
| p79-drift-validate | all 10 keys true |
| p79-otel-validate | all 13 keys true |
| p79-slo-validate | all 13 keys true |

## Executed Workstreams (live, this session)

### Recreate (true snapshot runtime reconstruction + 2 worker replacements)
- Two independent `shuffle-workers` replacements executed; E2E canary passed after each
  (strict-e2e-one / strict-e2e-two). `worker_before/after_one/after_two` captured.
- OpenSearch recreated via TRUE snapshot restore (runtime type = `snapshot`, not reindex);
  `snapshot_id = p79_snap_20260830t211135z`. `snapshot_consistency_recorded` and
  `true_runtime_rollback` (restore same snapshot to a verification index, parity confirmed).
- `security_state_after` (scoped dedup_writer grants; admin ops denied) and `ledger_parity`
  (create-only / dedup preserved) verified. `secured_reapply` confirmed (dedicated secrets +
  RBAC re-verified).
- Cluster is yellow (single-node replica unassignment) both before and after — non-data-affecting;
  documented honestly.

### Deployed E2E (action-task provenance, not host-side)
- Run through the deployed Wazuh→IRIS v2 workflow action task. `request_executor =
  shuffle_action_task`. Captured wazuh_alert_id, integratord_record_id, shuffle_service,
  action_task_id, action_container_id, node_id, network_namespace, task_local_dns/tcp/tls/auth,
  shuffle_execution_id, iris_object_id, direct_iris_readback, marker_parity.
- A reversible infra repair attached `shuffle-backend` to overlay `shuffle_swarm_executions`
  and pointed it at the overlay IP so worker tasks can stream results; fully reversible.

### Effectively-Once (eo) fault matrix — through deployed Shuffle
- Full fault matrix (partial_success, crash_after_accept, response_loss, timeout_ambiguity,
  reconciliation_blocks_replay, race_campaign) executed via the deployed action task;
  `destination_object_count = 1` proven two ways (in-task readback + independent IRIS DB count).
- `deployed_action_task = true`; create_only / occ / delivered_immutable all verified.
- Finding (carried, non-blocking): the canonical v2 is fail-open if the ledger claim throws;
  node code was restored to canonical v2 (verified) after testing.

### Runtime Drift (desired vs effective + recovery)
- `desired_hash` (sha256 over compose + v2 source + secret-grant spec) and `effective_hash`
  (sha256 over running service inspects + secrets/configs) computed. All facets match:
  network_match, secret_grants_match, trust_match, listener_match, workflow_revision_match.
- Unexpected-member test performed (temporary benign container on the overlay; detector flagged it);
  drift alert routed; after removal, recovery observed. Fully reverted.

### OTel resilience (persistent file_storage queue)
- Collector uses `file_storage` with directory_permissions 0750, queue_capacity 5000;
  `max_size` bounded by host-fs free space (contrib 0.118.0 lacks a native byte cap — documented).
- Backend outage (scoped 429 blackhole): peak_depth 72.6 MB, drop_count 0, drain_time 16 s;
  Class-A spans independent (send_failed_spans = 0). Restart survival confirmed (queue persisted).
- corruption_tested (byte-flip on a copy; acknowledged data never silently lost), authz_negative
  (scoped otel_collector denied foreign/admin writes), cardinality_measured, sensitive_scan_clean
  (no secret values in queue files) all PASS.

### SLO eligibility + burn-rate semantics
- Monitor counts ONLY deployed-eligible events (host-side excluded from budget).
- Fast/slow burn method + detection + clear measured via rule-state injection.
- compliance_window (30d rolling), reset_time (budget recovers as window slides),
  low_traffic_tested (no false page), zero_traffic_policy, external_paging_state = none
  (PAGE = local alert log; no external pager), capacity_in_health all PASS.

## IRIS Reachability (dev-approved repair)
- `ops/scripts/iris-gateway-publish.sh` confirms IRIS already published on the mct-security
  gateway; the v2 code resolves `iriswebapp_nginx` from within the action task with cert-verified
  TLS. Dev-environment repair, guarded by cron; not a new-artifact deploy.

## Residual / Carried Items
- Authority, current-vs-carried, historical-192-193 (documented as a KNOWN DUPLICATE FAILURE,
  not fixed), and other documentation reconciled and carried from Phase 78 canonical state.
- Full DR rehearsal, production alert routing, credential rotation, and container
  recreate-to-deploy remain operator sign-off gated (NO-GO without sign-off).
- No PVE host access; packet production unauthorized (shared constraints).

## Open / Gated (NO-GO without sign-off)
- Production routing enablement. Restore rehearsal against a chosen target. Credential rotation /
  token invalidation. Manual ISM / index intervention beyond scripted retention. Container
  recreate-to-deploy of a new artifact (distinct from the dev-approved repairs above).

## Evidence
Consolidated evidence JSONs under `ops/reports/evidence/phase79/`
(phase79-evidence-{recreate,deployed-e2e,eo,drift,otel,slo}.json), consumed by the validators
at argv[1]; every required key is genuinely true (no fabricated PASS).
