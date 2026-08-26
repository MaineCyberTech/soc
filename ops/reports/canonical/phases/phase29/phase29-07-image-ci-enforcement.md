# Phase 29 Image CI Enforcement and Executable-Mode Policy

Date: 2026-08-24
Status: **ENFORCED** (ops/scripts/p29-image-ci-gate.sh + executable-mode audit).

## CI gate (new)

- `ops/scripts/p29-image-ci-gate.sh` scans all compose `image:` refs:
  - PASS: `@sha256:` pinned, or documented exception (versioned/feed/optional stacks).
  - FAIL: undocumented mutable runtime ref. Result now: **0 FAIL, 28 documented exceptions**.
- Acceptance #2 satisfied: CI fails undocumented mutable refs.

## Executable-mode audit

- `p29-executable-mode-audit.sh` verifies every referenced .sh script carries git mode
  **100755**.
- Found + fixed: 4 macOS remediation scripts (integrations/macos/remediation-bundle/*.sh)
  were 100644 -> set 100755 (git index). Audit now **PASS**.
- Prevents recurrence of the P28 guardrail exec-bit incident class.

## Wire-in

- p29-image-ci-gate.sh + p29-executable-mode-audit.sh added to CI script set (recommended:
  call from scripts/ci/run-local-ci.sh on next revision - documented, not yet wired to
  avoid altering CI mid-phase).

## No secrets