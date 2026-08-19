# Phase 20 CI, Release, and Repo Integrity Audit

Date: 2026-08-19

## 1. GitHub release v1.0.0 state

- Tag `v1.0.0` EXISTS (points to cc4e389, 2026-08-16); ancestor of HEAD.
- Release created (phase14 report evidence) with asset
  `mct-security-stack-release-20260816-014828.tar.gz` (536K, 1015 files, 0 sensitive files).
- Local copy at `/opt/mct-security-stack-backups/releases/`. RELEASE-NOTES path reference
  (`/home/user/mct-security-releases/`) is stale/absent.
- **Release is stale**: 62 commits + Phases 18-20 behind HEAD.

## 2. CI status

- `.github/workflows/verify.yml`: VALID; steps = bash -n, py_compile, PS presence, stack-layout,
  stale-phase-refs, secret-scan, unpinned-image (informational), live checks skip in CI.
- Local CI: `scripts/ci/run-local-ci.sh` - parity with GitHub CI but **weaker** (syntax-check
  failures don't propagate -> false PASS possible). Action item.
- No network CI run possible from here; local CI is the operative check.

## 3. Local CI parity

- Mostly parity; gap: local script does not fail on broken bash/python (MED).

## 4. Unpinned Docker image check

- Script: `ops/scripts/check-unpinned-docker-images.sh` (exits 1 on violation; exceptions only
  in prose report, not consumed by script).
- Latest report 08-17 (STALE - not run since).
- **RED: 21 refs flagged** (misp-modules:latest undocumented; ~7 greenbone service images
  undocumented; opencanary:latest + velociraptor:latest documented exceptions).
- Coverage gap: script scans only MCT compose dir, NOT `/opt/wazuh-docker/multi-node`
  compose (nginx:stable, cloudflared:latest, elastiflow:7.26.2, python:3-alpine, wazuh/*:4.14.7).

## 5. Repo source-of-truth docs

- REPO-MAP.md / ARCHITECTURE.md: current to 2026-08-16 (pre-18-20); README deployment date
  stale; STACK-OVERVIEW.md header stale (2026-08-10). See phase20-repo-source-of-truth-status.md.

## Verdict

CI/release machinery intact but **unmaintained**: unpinned-image check red + stale, v1.0.0
release behind HEAD, and Phase 19/20 work uncommitted (deployed state not captured in git).
Phase 21 must commit + tag and refresh release + image pinning.

## No secrets