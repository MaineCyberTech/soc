# Phase 31 CI Image Gate Wiring

Date: 2026-08-24
Status: **WIRED (hosted CI, fail-closed)**.

- Added to .github/workflows/verify.yml: step runs `p29-image-ci-gate.sh`, fails on any
  undocumented mutable image ref. Local PASS (28 documented exceptions, 0 fails).
- Summary format via p31-ci-summary.sh (PASS|image-gate|none|No action).

## No secrets
