# Phase 30 v1.3.0 Running Digests Reconcile

Date: 2026-08-24
Tooling: p30-runtime-drift-audit.sh.

## Desired (compose) vs running

- All 8 mutable refs digest-pinned in compose AND running runtime (verified P29, reconfirmed).
- Non-digest refs in active compose: none (only versioned/feed exceptions in optional
  misp/greenbone stacks - documented).
- Executable modes: **all tracked .sh now 100755** (fixed p29-image-ci-gate.sh this phase;
  0 non-exec tracked).

## Drift

- No desired-vs-running image drift among active runtime. Versioned-tag containers
  (wazuh 4.14.7, iris v2.4.29, frikky 1.x, elastiflow 7.26.2, opensearch 3.2.0, rabbitmq,
  nginx stable, portainer sts) = documented exceptions, not drift.

## No secrets