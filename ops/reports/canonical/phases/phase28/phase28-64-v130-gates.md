# Phase 28 v1.3.0 Release Gates

Date: 2026-08-24
Status: **GATES READY - APPROVAL PENDING** (no automatic release).

## Gates

| Gate | Status |
|---|---|
| Deployability certificate | PARTIAL (P0 closed) |
| Clean repo (P28 committed) | PENDING (phase close) |
| CI / secret / audits | PASS (61/62) |
| Source docs | current (README v1.2.0; add v1.3.0) |
| Release notes | v1.3.0 section to add |
| Bundle safety | rebuild (0 sensitive files; excludes data/, velociraptor keys) |
| Manifest/hash | dependency-lock.json + bundle manifest |
| **Approval** | **PENDING** (operator) |
| Rollback | tag delete + release discard |

## v1.3.0 candidate highlights

- Guardrail restored (exec-bit fix) + failover re-validated; consolidation audit stack
  (inventory/canonical/dependency-lock/config profiles/clean-deploy) delivered.
- DR: full-cluster architecture + runbook (component drills PASSED; full-cluster NO-GO
  documented honestly).
- New artifacts: config/{dependency-lock,schema,service-graph}.json, config/profiles/,
  ops/scripts/p28-* tooling.
- Endpoint certification PARTIAL (013/014 marker pending) - noted in release notes.

## Decision

- **APPROVAL PENDING** - technical gates staged.

## No secrets