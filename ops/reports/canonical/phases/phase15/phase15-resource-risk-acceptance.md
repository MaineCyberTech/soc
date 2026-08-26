# Phase 15 Resource Risk Acceptance

Date: 2026-08-16

## Principle

Low-resource tuning must NOT weaken core detection, backup, or client safety
without explicit acceptance.

## Accepted this phase

- NONE (no telemetry/backup changes made - only reporting + documentation).

## Pending acceptance (deferred)

1. ES snapshot cleanup (43->14): acceptable IF a fresh snapshot exists post-cleanup.
2. shuffle-opensearch mem_limit: acceptable IF Shuffle healthcheck passes post-change.
3. tenzir-node pause: requires flow-collection verification.
4. Digest pinning recreate: requires healthcheck post-recreate.

## Rule

- Any future tuning that reduces telemetry/backups requires this file updated
  with explicit operator sign-off.

## No secrets
