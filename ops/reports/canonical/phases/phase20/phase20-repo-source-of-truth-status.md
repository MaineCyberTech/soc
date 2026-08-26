# Phase 20 Repo Source-of-Truth Status

Date: 2026-08-19

| Doc | Exists | Status | Action |
|---|---|---|---|
| /opt/mct-security-stack/README.md | yes | stale (deployment date 2026-08-10; predates v1.0.0 + P14-20) | refresh |
| /opt/mct-security-stack/ARCHITECTURE.md | yes | 2026-08-16; agent list missing 013/015+ | refresh agent list |
| /opt/mct-security-stack/REPO-MAP.md | yes | 2026-08-16; does not list scripts/ci/ | minor update |
| /opt/mct-security-stack/RELEASE-NOTES.md | yes | v1.0.0 (2026-08-16); no P18-20 notes | add P18-20 notes |
| /opt/mct-security-stack/PORTABILITY.md | yes | current | - |
| /opt/wazuh-docker/multi-node/ops/STACK-OVERVIEW.md | yes | header stale 2026-08-10; content to 08-15 | update header |
| verify-no-stale-phase-refs.sh | n/a | only scans runbooks/checklists/integrations, NOT top-level docs | extend scope |

## Key gap

Deployed Phase 20 state is not captured in git (77 uncommitted files; HEAD = Phase 18).
Source-of-truth docs are frozen at v1.0.0 (2026-08-16). Phase 21: commit Phase 19/20,
refresh source-of-truth docs, tag a new release.

## No secrets