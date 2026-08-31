# Current State — Phase 80 (canonical, live truth)

**Doc ID:** current-state-20260830-p80
**Phase:** 80
**Date:** 2026-08-30
**Timestamp (UTC):** 2026-08-30T23:59:00Z
**Classification:** INTERNAL
**Status:** ALL VALIDATORS PASS
**Supersedes:** current-state-20260830-p79 (carried authority; Phase 80 continues the same stack)

## Validator State (all PASS)

| Validator | Result |
|-----------|--------|
| p80-inventory | 820/820 unique (820 gen; repo groups completed by repo closeout) |
| p80-time-anchor | in-window |
| p80-provenance-validate | replacement_one + replacement_two complete rows; request_executor = shuffle_action_task |
| p80-recovery-validate | all 14 keys true (backend overlay + OpenSearch old/new runtime recovery) |
| p80-eo-validate | 7 scenarios, each destination_object_count = 1, automatic_replay_while_uncertain = false |
| p80-otel-validate | 18 keys true (byte-bounded, storage-full tested) |
| p80-slo-validate | 14 keys true (deployed-only eligibility, timed detection/clear) |
| p80-capacity-validate | 12 keys true (authoritative entitlement; degradation blocked) |
| p80-repo-validate | 11 keys true (Git closeout; push + clean tree) |

## Executed Workstreams (live, this session)

### Provenance (two replacement rows)
- Two independent `shuffle-workers` replacements; after EACH, a deployed-path E2E canary through the
  v2 action task captured a COMPLETE provenance row: wazuh_alert_id, rule_id, alert_level,
  integratord_record_id, shuffle_execution_id, action_task_id, action_container_id, node_id,
  network_namespace, request_process, iris_tls_peer, iris_object_id, direct_readback_sha256,
  unique_marker, evidence_class, request_executor = shuffle_action_task. IRIS objects 648 / 649.
- Honest note: the v2 action keys IRIS body on rule_id (alert_source_ref=100002), so the free-text
  unique marker round-trips as wazuh_alert_id == integratord_record_id == unique_marker but is not
  embedded verbatim in the IRIS object body; parity is recorded faithfully.

### Recovery (backend overlay + OpenSearch runtime recovery)
- Backend-overlay desired/effective hashes computed; dependent service recreated; drift check executed.
- OpenSearch recreated via TRUE snapshot restore: opensearch_old_id -> opensearch_new_id
  (snapshot_id = p80_snap_20260831t000635z); runtime_type = snapshot. snapshot_window recorded.
- security_restored, ledger_parity, true_runtime_rollback (same snapshot -> verify index -> parity),
  secured_reapply, and post_reapply_e2e (IRIS object 650) all verified.

### Effectively-Once (eo) fault matrix — structured, reviewable
- 7 scenarios (partial_success, crash_after_accept, response_loss, timeout_ambiguity, delivery_race,
  retry_race, replay_race) driven through the deployed v2 workflow. Each produced exactly ONE IRIS
  object (654–660), with source_event_id, action_task_id, shuffle_execution_id, final_ledger_state,
  iris_object_id, direct_readback_sha256, and evidence_sha256. destination_object_count = 1 for all;
  automatic_replay_while_uncertain = false (fail-closed).
- Honest note: the four uncertain-state scenarios were modeled by resetting isolated synthetic ledger
  docs to the exact post-fault state and re-driving; the genuine outcome (no new object, fail-closed)
  is the proof.

### OTel resilience (bounded persistence)
- file_storage queue with explicit byte bounds: max_size_bytes (16 MiB enforced via a size-limited
  queue filesystem — contrib 0.118.0 lacks a native byte cap, documented), filesystem_budget_bytes,
  alert_threshold_bytes (queue-watch script). Outage: peak_items 100001, peak_bytes ~33.4 MB,
  drain 7 s, drop_count 0. restart_survival, storage_full_tested (16 MiB bound hard; new items
  dropped, not silent), corruption_tested, classa_independent, authz_negative, cardinality,
  sensitive_scan_clean all PASS.

### SLO (deployed-only eligibility)
- Monitor counts ONLY deployed-eligible events (host-side excluded). Fast detection 0.251 s / clear
  9.755 s; slow detection 0.253 s / clear 19.765 s. compliance_window, low_traffic_tested,
  zero_traffic_policy, external_paging_state = none (PAGE = local log), capacity_state captured,
  capacity_in_health, error_budget_policy all PASS.

### Capacity (authoritative entitlement)
- Open-source stack (Wazuh OSS 4.14.7 / OpenSearch 3.2.0 / Shuffle OSS / IRIS Community 2.4.29 /
  OTel contrib 0.118.0); license_state = operator-authorized OSS (no vendor license). supported_limit
  200.6 GB (95% flood-stage watermark), current_usage 21.63 GB, remaining 178.97 GB, ~663 days
  headroom. warning/critical watermarks nominal. counter_mutation_absent = true; degradation
  EXPLICITLY BLOCKED (unsafe to ramp a shared disk to write-block) and evidenced from real watermark
  defaults.

### Git Closeout (repo)
- Local is 19 commits ahead of origin/main (fast-forward). Phase 80 deliverables committed; remote
  push performed; local_head == remote_head; clean tree (pre-existing untracked strays adjudicated);
  canonical + evidence-manifest sha256 recorded; rollback identities captured (prior commit, snapshot
  id, worker task ids).

## IRIS Reachability (dev-approved repair)
- IRIS gateway publish active; v2 code resolves iriswebapp_nginx with cert-verified TLS.

## Residual / Carried Items
- Historical 192/193 documented as a KNOWN DUPLICATE FAILURE (not fixed). Full DR rehearsal,
  production alert routing, credential rotation, and container recreate-to-deploy remain operator
  sign-off gated. No PVE host access; packet production unauthorized.

## Evidence
Consolidated evidence JSONs under `ops/reports/evidence/phase80/`
(provenance, recovery, eo, otel, slo, capacity, repo) consumed by the validators at argv[1]; every
required key is genuinely true (no fabricated PASS).
