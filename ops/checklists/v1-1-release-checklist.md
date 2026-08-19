# v1.1.0 Release Checklist

Date: 2026-08-19
Status: PREPARED - release NOT yet created (approval-gated).

## Pre-release gates (must ALL pass)

- [x] Phase 19/20/21 work committed and pushed to `main` (P21.1-P21.4 pushed 2026-08-19).
- [x] Local CI passes (`scripts/ci/run-local-ci.sh` -> PASS after false-PASS fix).
- [x] Secret scan passes (no live secret values in repo source).
- [x] Hardcoded credential defaults removed (3 scripts fail-fast).
- [x] wazuh-docker public-origin clone protected (skip-worktree/exclude; no secrets pushed).
- [x] RELEASE-NOTES.md updated with Phases 18-21 summary (draft v1.1.0 section).
- [ ] Operator approval for tag + release creation.
- [ ] Push of the final phase-21 commit (incl. RELEASE-NOTES draft + phase21 reports).

## Optional/backlog before release

- [ ] Rotate VirusTotal API key + indexer password (they existed in on-disk tracked working trees).
- [ ] Templatize docker-compose.yml / docker-compose.override.yml literals to `${VAR}`.
- [ ] Pin remaining non-Greenbone unpinned images (opencanary, cloudflared, misp-modules, nginx, python, elastiflow, syslog-ng) or keep documented exceptions.

## Release steps (after approval)

1. `git tag -a v1.1.0 -m "MCT Security Stack v1.1.0 - Phase 21 baseline"`
2. `git push origin v1.1.0`
3. Create GitHub release via `gh release create v1.1.0 --notes-from-tag` (or API) with portable bundle asset
   (re-run `scripts/ci/build-release-bundle.sh` -> `/opt/mct-security-stack-backups/releases/`).
4. Update README CI badge/release date + REPO-MAP/ARCHITECTURE if needed.

## Blockers

- Release/tag creation: **pending operator approval** (safety rule: no release until cleanup + CI/secret pass; they pass, approval is the remaining gate).

## No secrets