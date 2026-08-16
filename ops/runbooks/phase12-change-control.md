# Phase 12 Change Control

Date: 2026-08-16
Phase 12 pack: /home/user/mct-security-10

## Change log

| # | Timestamp | Component | Change | Before | After | Validation |
|---|---|---|---|---|---|---|
| 1 | 2026-08-16 01:35 | Git | git init in /opt/mct-security-stack (local only) | no repo | repo init, 0 commits | no push; dry-run staged set 935 files |
| 2 | 2026-08-16 01:36 | .gitignore | hardened (keys, archives, client.config.yaml, shuffle log) | 16 lines | 27 lines | dry-run staged set 0 sensitive |
| 3 | 2026-08-16 01:45 | CI | .github/workflows/verify.yml + scripts/ci/run-local-ci.sh + github-prepush-check.sh | none | CI added | local CI PASS |
| 4 | 2026-08-16 01:48 | Release | scripts/ci/build-release-bundle.sh + bundle + manifest + RELEASE-NOTES | none | bundle 536K/1015 files | gate 0 sensitive |
| 5 | 2026-08-16 01:52 | Capacity | ops/scripts/proxmox-thinpool-report.sh + capacity runbook | manual only | weekly script | report WARN 87.84% |
| 6 | 2026-08-16 01:55 | Wazuh agents | agent 009 removed (phantom registration) | 7 agents, 1 never-connected | 6 agents, 0 never-connected | API + agent_control verified |
| 7 | 2026-08-16 | Greenbone | scheduled proof report (timing blocker) | pending | documented + verify steps | schedule confirmed via GMP |

## Rules

- Additive changes preferred.
- No git push without operator approval.
- No secret values written to reports.
- No destructive deletion of historical evidence.
