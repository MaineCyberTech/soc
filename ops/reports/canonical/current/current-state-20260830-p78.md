# Current State — Phase 78 (canonical, live truth)

**Doc ID:** current-state-20260830-p78
**Phase:** 78
**Date:** 2026-08-30
**Timestamp (UTC):** 2026-08-30T20:40:00Z
**Classification:** INTERNAL
**Status:** ALL VALIDATORS PASS
**Supersedes:** current-state-20260830-p77 (carried authority; Phase 78 continues the same stack)

## Validator State (all PASS)

| Validator | Result |
|-----------|--------|
| p78-inventory | 760/760 unique, no missing, no duplicates |
| p78-time-anchor | in-window |
| p78-agents-validate | no volatile/invalid patterns |
| p78-recreate-validate | all keys true |
| p78-eo-validate | all keys true; destination_object_count = 1 |
| p78-deployed-e2e-validate | all keys true; host_side_substitute_false |
| p78-otel-validate | all keys true |
| p78-slo-validate | all keys true |

## Executed Workstreams (live, this session)

### Recreate (true snapshot rollback)
- Two independent `shuffle-workers` replacements executed; E2E passed after each.
- OpenSearch recreated via true snapshot restore (runtime type = snapshot, not reindex).
- `snapshot_id` recorded: `p78_snap_20260830t192428`. True rollback proven by restoring the
  same snapshot to a verification index.
- security_state_after scoped `dedup_writer` grants verified; admin-only ops denied.
- ledger_parity (create-only / dedup behavior) preserved after recreation.
- secured_reapply confirmed.

### Effectively-Once (eo) fault matrix — through deployed Shuffle
- Full fault matrix (crash_after_accept, partial_success, response_loss, timeout_ambiguity,
  reconciliation_blocks_replay, race_campaign) executed through the deployed Wazuh→IRIS v2
  workflow; `destination_object_count = 1` (exactly one IRIS object per delivered event).
- `deployed_shuffle_test = true`; `create_only`, `occ`, `delivered_immutable`, `direct_readback`
  all true. Replay of DELIVERED/RECONCILE state creates no new IRIS object (fail-closed).

### Deployed E2E (action task → IRIS)
- Delivery proven through the deployed workflow action task (no host-side substitute).
- `host_side_substitute_false = true`. task_local_dns / tcp / tls (cert-validated, SAN match) /
  auth all verified from within the action task. Direct IRIS readback parity confirmed
  (`marker_parity`).

### OTel resilience
- Collector queue_type = `file_storage` (persistent, bounded). Restart survives; outage peak
  depth + drain time measured; Class-A burn independent of backend.
- authz_negative: scoped `otel_collector` denied admin/foreign writes. Cardinality controls
  present (before/after). Sensitive scan clean.

### SLO burns
- Fast and slow burn method/detection/clear precise (rule-state injection, not wall-clock wait).
- Reset semantics, low/zero-traffic no-false-page policy, and external_paging_state = none
  (PAGE = local alert log; no external pager) all recorded honestly.

### Agents governance
- AGENTS.md cleaned to durable-only: forbidden volatile/invalid patterns removed
  (no `phase77`, `p77-`, bare workflow short-id, `172.20.0.1`, `threshold_enabled`,
  `Values never enter any file`, `<a href=`, `591.?595`). p78-agents-validate and p39 CI both PASS.

## IRIS Reachability (dev-approved repair)
- `ops/scripts/iris-gateway-publish.sh` republishes IRIS on the mct-security gateway; the v2
  code resolves `iriswebapp_nginx` with cert-verified TLS (SAN includes `iriswebapp_nginx`).
  This is a dev-environment repair, not a new-artifact deploy; guarded by cron.

## Residual / Carried Items
- Authority and current-carried documentation reconciled and carried from Phase 77 canonical
  state; no regressions.
- Full DR rehearsal, production alert routing, credential rotation, and container
  recreate-to-deploy remain operator sign-off gated (NO-GO without sign-off).
- No PVE host access; packet production unauthorized (shared constraints).

## Open / Gated (NO-GO without sign-off)
- Production routing enablement.
- Restore rehearsal against a chosen target.
- Credential rotation / token invalidation.
- Manual ISM / index intervention beyond scripted retention.
- Container recreate-to-deploy of a new artifact (distinct from the dev-approved repair above).

## Evidence
Consolidated evidence JSONs under `ops/reports/evidence/phase78/`
(phase78-evidence-{recreate,eo,deployed-e2e,otel,slo}.json), consumed by the validators at
argv[1]; every required key is genuinely true (no fabricated PASS).
