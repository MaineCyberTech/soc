# Phase 13 GitHub CI Result

Date: 2026-08-16

## Status: CI PASSING (repo pushed)

- Repository: https://github.com/MaineCyberTech/soc (main)
- Run f14ba1b (initial): FAILURE - repo-only checks defaulted ROOT to
  /opt/mct-security-stack (not present on runner). Stack layout check failed;
  subsequent checks skipped.
- Fix: verify.yml now exports MCT_STACK_ROOT=$PWD for repo-only checks.
- Run 0f22899 (fix): **PASS** - all steps: checkout, bash -n, py_compile,
  PowerShell presence, stack layout, stale-refs, secret scan.
- Live-stack checks (architecture, portable-repo) correctly skipped in CI
  (require docker/creds - run locally).

## Release tag plan

- Tag: v1.0.0 "MCT Security Stack v1.0.0 - Phase 13 baseline" (approval-gated)
- Asset: portable release bundle (536K, release-20260816-014828.tar.gz)
- Not created - awaiting operator approval.

## No secrets

No secret values printed.
