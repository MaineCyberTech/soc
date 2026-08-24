# Phase 31 Drift Reconciliation

Date: 2026-08-24

- Canonical vs running: images pinned (no drift); guardrail toggle intentional.
- CI workflow vs repo tooling: gates wired (image/exec-mode) - no drift.
- Health rules vs actual: SO removed from mandatory failures (RETIRED) - reconciled.
- Sensor config: repo integrations/suricata-minimal = deployed config (scp'd) = config gate
  validated.

## No secrets
