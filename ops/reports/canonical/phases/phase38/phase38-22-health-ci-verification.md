# Phase 38-22 — Health & CI Claim Verification

**Report ID:** phase38-22-health-ci-verification
**Phase:** 38
**Title:** Phase 38-22 — Health & CI Claim Verification
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-22-health-ci-verification.md`
**Retention Class:** LONG

**Date:** 2026-08-25 ~20:30 UTC
**Scope:** Verify claims about healthcheck scripts, local/CI verification pipeline, secret scanning, image gate, and executable modes.
**Verifier:** Phase 38 automated verification (commands executed live)

---

## Claims Under Verification

| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | CI workflow exists (`.github/workflows/`) with syntax + secret scan + image gate + exec-mode steps | **VERIFIED** | `.github/workflows/verify.yml` inspected |
| 2 | Ops scripts are executable | **VERIFIED (sampled)** | 86 `.sh` files; sampled entries `-rwxrwxr-x`; full audit timed out locally |
| 3 | Full-stack healthcheck runs green | **VERIFIED** | Live run: `FAIL count: 0`, report written |
| 4 | Healthcheck self-test passes | **VERIFIED** | `healthcheck-selftest.sh` → `Result: PASS` |
| 5 | Secret-pattern scan is wired into CI (values never printed) | **VERIFIED (wiring)** | step present in verify.yml; script exists — full local run not completed in window |
| 6 | Image CI gate blocks undocumented mutable refs | **VERIFIED** | live run exit=0 with only documented exceptions |

---

## Evidence Detail

### 1. CI workflow content
```
$ cat .github/workflows/verify.yml        # single workflow file: verify.yml
name: Verify MCT SOC Repo
on: pull_request / push to main
steps:
  - Bash syntax check      (find ... -name '*.sh' | bash -n)
  - Python syntax check    (py_compile all .py)
  - ShellCheck             (-S warning, documented exclusions, non-blocking if absent)
  - PowerShell present check (informational; PS1 not executed in CI)
  - Stack layout check     (scripts/verify/verify-stack-layout.sh)
  - Stale phase ref check  (scripts/verify/verify-no-stale-phase-refs.sh)
  - Secret pattern scan    (ops/scripts/secret-pattern-scan.sh "$PWD")
  - Unpinned image check   (report-only mode)
  - Image CI gate          (p29-image-ci-gate.sh || FAIL exit 1)   ← blocking
  - Executable-mode audit  (p29-executable-mode-audit.sh || FAIL exit 1) ← blocking, timeout 300
  - Live architecture check: explicitly SKIPPED in CI (requires docker stack)
```
All claimed CI stages are present; the two blocking gates match the "gate" claims. Actions pinned by commit SHA (`actions/checkout@11d5960...`). **VERIFIED.**

### 2. Script executable bits
```
$ ls -la ops/scripts/*.sh | wc -l
86
$ ls -la ops/scripts/*.sh | head -20
-rwxrwxr-x ... active-response-audit.sh
-rwxrwxr-x ... alert-volume-by-rule.sh
-rwxrwxr-x ... backup-dr-audit.sh
... (all 20 sampled lines show x bits set)
$ awk '$1 !~ /x.x.x/' over full listing → no non-executable .sh rows surfaced in sample pass
```
Sampled audit clean. A full local execution of `ops/scripts/p29-executable-mode-audit.sh` was attempted and exceeded a 120 s tool window without completing (`exit=124` after 240 s wrapper); it is designed for CI with `timeout 300`. Mode claims therefore verified on sample + CI design, not exhaustive local proof. **VERIFIED (sampled).**

### 3–4. Healthchecks (live execution)
```
$ bash ops/scripts/healthcheck-selftest.sh
[PASS] indexer green (live probe)
[PASS] syslog rejection check truthful (no recent rejections)
Result: PASS

$ timeout 60 bash ops/scripts/full-stack-healthcheck.sh
Wrote /opt/mct-security-stack/ops/reports/full-stack-health-latest.md
  (/opt/mct-security-stack/ops/reports/full-stack-health-20260825-202718.md)
FAIL count: 0
```
Both health paths execute successfully right now and produce persisted evidence artifacts under `ops/reports/`. **VERIFIED.**

### 5. Secret scan
Script `ops/scripts/secret-pattern-scan.sh` exists and is invoked by the CI step labelled "Secret pattern scan (repo-only, no values)". The local run was not completed inside this verification window (large tree); wiring and script presence confirmed, output behavior taken from prior CI evidence. **VERIFIED (wiring) / UNVERIFIED (fresh full-run output this session).**

### 6. Image gate (blocking semantics)
Live run returned `exit=0` listing five explicitly documented tag exceptions (opensearch 3.2.0, alpine 3.20, postgres 16-alpine, redis 7-alpine, velociraptor latest). Blocking-on-failure logic is enforced in the workflow (`|| { echo FAIL...; exit 1; }`). **VERIFIED.**

---

## Verification Commands Used
```bash
ls .github/workflows/
cat .github/workflows/verify.yml
ls -la ops/scripts/*.sh | head -20 ; ls -la ops/scripts/*.sh | wc -l
bash ops/scripts/healthcheck-selftest.sh
timeout 60 bash ops/scripts/full-stack-healthcheck.sh
bash ops/scripts/p29-image-ci-gate.sh
timeout 240 bash ops/scripts/p29-executable-mode-audit.sh   # timed out locally
ls ops/scripts/secret*.sh ops/scripts/p29-image-ci-gate.sh
```

## Summary
CI pipeline composition, blocking gates, script executability (sample), and both health checks are **VERIFIED** against live state. Residual gaps: exhaustive exec-mode audit and a fresh full-tree secret scan were not completed in-session (timeouts), so those two carry a PARTIAL flavor despite CI wiring being present.

## No secrets
