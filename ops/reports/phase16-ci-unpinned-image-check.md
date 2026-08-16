# Phase 16 CI Unpinned Image Check

Date: 2026-08-16

## Status: IMPLEMENTED (informational)

## Files

- ops/scripts/check-unpinned-docker-images.sh - detects unpinned refs,
  allows versioned tags baseline, exits 1 on violations.
- .github/workflows/verify.yml - new step (informational, non-blocking).
- scripts/ci/run-local-ci.sh - added step (PASS with note).

## Behavior

- Local CI: reports violations + continues (PASS).
- GitHub Actions: reports violations + note (does not fail the workflow).

## Current result

- Violations: 29 unpinned refs remain (MISP modules, Greenbone feeds, DB tags
  excluded as versioned) - documented backlog.
- Once backlog is pinned, flip step to hard-fail.

## No secrets
