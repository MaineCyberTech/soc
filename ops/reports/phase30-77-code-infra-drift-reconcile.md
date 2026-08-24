# Phase 30 Code / Infrastructure Drift Reconcile

Date: 2026-08-24
Status: **RECONCILED**.

## Drift items addressed

| Drift | Action |
|---|---|
| p29-image-ci-gate.sh mode 100644 | fixed -> 100755 (all tracked .sh now 100755) |
| 3 pack scripts wrong CI path | fixed (scripts/ci/run-local-ci.sh canonical) |
| Running containers predate compose pins | reconciled P29 (all 8 pinned in runtime) |
| Scorecard generators canonical map | corrected (ops/scripts) - P29 |
| Stale v1.2.0 release language | none (history entries correct) |
| runtime config vs canonical (guardrail) | intentional skip-worktree toggle - accepted |

## Accepted (documented)

- Vendored IRIS source warnings; reporting/generators duplicates (deprecated, evidence);
  indexer unbounded limits (scheduled); tenzir standalone (pin recorded).

## Verdict

- **Reconciled or explicitly accepted** (no hidden drift).

## No secrets