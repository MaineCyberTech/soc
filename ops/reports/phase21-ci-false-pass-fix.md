# Phase 21 CI False-PASS Fix

Date: 2026-08-19

## Root cause

`scripts/ci/run-local-ci.sh` bash/python syntax-check loops ran inside `while read` pipelines
(subshells), so any `FAIL=1` set inside the loop never propagated to the parent shell. Two
redundant bash loops existed; the `BFAIL=0` variable was declared but never used. Result:
broken scripts printed `SYNTAX FAIL`/`PYTHON FAIL` but CI still reported `RESULT: PASS`.

## Fix applied

- Rewrote bash + python syntax checks to collect failures into a temp file (`mktemp`) and,
  if non-empty, print them and set `FAIL=1`.
- Removed the duplicate bash loop.
- Verified:
  - Clean tree -> `RESULT: PASS`.
  - Injected broken `zzci-test-bad.sh` -> `SYNTAX FAIL: ./zzci-test-bad.sh` +
    `RESULT: ACTION REQUIRED` (exit 1).
  - After removal -> PASS restored.

## Effect

Local CI now fails on real shell/python errors, matching GitHub CI behavior (which already
failed correctly via pipefail).

## No secrets