# Phase 11 Documentation Normalization

Date: 2026-08-16

## Goal

Remove stale phase/pack language from CURRENT operational docs so they read as
durable "MCT Security Stack" documentation, while preserving historical evidence.

## Scan result

- **Pack language**: ZERO hits ("pack root", "prompt pack", "OpenCode pack run").
- **Phase language**: pervasive in current docs because "Phase 2" was the
  canonical stack name. ~30 current files normalized.
- Historical reports (dated filenames, final-phase*-operator-reports) EXCLUDED
  from modification - preserved as evidence.

## Files normalized (current operational docs)

### Canonical docs
- README.md: title "MCT Phase 2 Security Stack" -> "MCT Security Stack"; cron
  labels, safety rules normalized.
- STACK-OVERVIEW.md (Wazuh ops): "Phase 2 — SOC build-out" section -> "SOC
  build-out"; gotchas + pointer normalized.

### Runbooks (18)
- safe-mode.md, break-glass.md, dfir-iris.md, shuffle.md, misp.md,
  velociraptor.md, credential-rotation-checklist.md, disaster-recovery-addendum.md,
  windows-endpoint-onboarding.md, alert-routing-tuning.md, opencanary.md,
  secret-hygiene.md, scorecard-delivery.md, backup-cron-operations-phase8.md,
  levelio-rollout-phase8.md, mct-canary01-phase8-operations.md,
  dr-scratch-restore-execution-phase8.md, phase2-backup/restore/rollback.md,
  phase2-validation.md, phase3-rollback-verification.md, phase3-restore-map.md,
  phase4-change-window.md, phase4-credential-rotation-window.md,
  phase4-rollback-index.md, phase5-*.md, phase6-*.md, canarytokens-operations.md

### Integration docs
- integration-matrix.md, failure-modes.md, wazuh/classification-matrix.md,
  opencanary/canary-vm-plan.md, levelio/client-group-naming-standard.md,
  flow/approved-exporters.md, opencanary/wazuh-rules-plan.xml

### Reports (current)
- ops/reports/ports.md: "port registry for the phase 2 stack" -> "Port Registry
  (MCT Security Stack)"

### Client-onboarding
- README.md: version stamp de-phased.

## Not modified (by policy)

- Historical timestamped reports (preflight-*, final-phase*-operator-report-*,
  full-stack-health-*, phase[0-8]-* dated files).
- Decision/plan docs where phase references are historical narrative
  (workload-move-decision.md, canarytokens-phase6-deployed.md,
  canarytokens-plan.md).

## Result

- Current docs now use "MCT Security Stack" / "stack services" durable language.
- No critical stale references remain outside historical evidence.
- Port model (15140) and SO packet-ingestion model already correct (P9/P10).

## No secrets

No secret values printed.
