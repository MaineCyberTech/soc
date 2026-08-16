# Phase 13 Level.io Simulation Results

Date: 2026-08-16

## Status: PASS (Linux harness), Windows harness ready (pwsh not on host)

## Linux/macOS harness (scripts/endpoint-deploy/test/simulate-levelio-linux.sh)

| Test | Result |
|---|---|
| 1. Env-var success path (dry-run) | PASS - WAZUH_MANAGER consumed, WAZUH_REG_PASSWORD=<set:redacted>, exit 0 |
| 2. CLI-arg success path (dry-run) | PASS - --manager overrides env, exit 0 |
| 3. Missing required variable | PASS - exit 2 + clear message |
| 4. Unresolved {{placeholder}} | PASS - exit 2 (NOT silently used as value) |

## Windows harness (scripts/endpoint-deploy/test/simulate-levelio-windows.ps1)

- Present, syntax checked; not executable here (pwsh not installed on host).
- Test cases: env success (-DryRun) + missing required (exit 2).
- To run: `pwsh -File scripts/endpoint-deploy/test/simulate-levelio-windows.ps1`

## Proof of fix

- Test 4 proves the root cause is resolved: an unresolved `{{VAR}}` placeholder
  now fails fast instead of being used as a literal manager address (the
  "variables set but not used" failure mode).

## Harness runner

- scripts/ci/run-levelio-variable-tests.sh - runs both harnesses; exit 0/1.
- Recommended: add to CI (GitHub Actions) once Windows runner or pwsh available.

## No secrets

No secret values printed.
