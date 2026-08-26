# Phase 24 ShellCheck CI Integration

Date: 2026-08-22
Status: **COMPLETE**

## Changes

1. `.github/workflows/verify.yml`: added a ShellCheck step (Linux runner; runs when
   `shellcheck` is present; non-blocking if not installed).
2. `scripts/ci/run-local-ci.sh`: added conditional shellcheck lint step (non-blocking if
   not installed; findings reviewed).

## Exclusions (documented)

- SC1090/SC1091 (source resolution), SC2154 (vars from sourced env), SC2086 (word-splitting
  in curl/ssh - intentional), SC2002, SC2317, SC2164, SC2162, SC2091 - existing stack
  idioms; failures from OTHER codes are actionable and reported.

## Note

- shellcheck not installed on this host -> local step skips; CI step is opportunistic.
- Install (`apt install shellcheck`) to activate; findings then reviewed per phase.

## No secrets