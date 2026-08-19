# Phase 21 Repo Hygiene Review

Date: 2026-08-19
Repo: /opt/mct-security-stack (branch main; origin MaineCyberTech/soc)

## State at start

- HEAD: `eba217b Phase 18 final operator report` (2026-08-17).
- **82 untracked + 1 modified** file (non-log, non-health) - all Phase 19/20/21 work uncommitted.
- Tag `v1.0.0` (cc4e389) is 62+ commits behind working tree.

## Classification of uncommitted work

| Group | Files | Type | Commit? |
|---|---|---|---|
| Phase 19 integrations | integrations/{macos,security-onion,shuffle,dfir-iris,elastiflow,syslog}/phase19-* | source-of-truth docs + **zeek rules v2.2 XML (deployed config)** | YES |
| Phase 20 integrations | integrations/{macos,security-onion,shuffle,dfir-iris,elastiflow,syslog}/phase20-* | source-of-truth docs | YES |
| Phase 19 reports | ops/reports/phase19-*.md, final-phase19 | operator reports | YES (repo pattern commits final reports) |
| Phase 20 reports | ops/reports/phase20-*.md, final-phase20 | audit/operator reports | YES |
| Phase 21 (this) | ops/reports/phase21-preflight, phase21-phase20-status-review | in-progress | YES (with phase 21 close) |
| Runbook | ops/runbooks/index-retention-policy.md | source-of-truth | YES |
| Service-packaging | service-packaging/phase20-billing-readiness.md | client ops doc | YES |
| Client-onboarding | client-onboarding/phase19-client-scan-authorization-status.md | status doc | YES |
| Generated ops | ops/reports/proxmox-thinpool-report-20260819-063204.md | generated report (repo tracks prior thinpool reports) | optional/YES |
| Tracked log | ops/reports/backup-log.txt (M) | operational log dirtying status | **NO - untrack it** |

## Files that should NOT be committed

1. `ops/reports/backup-log.txt` (and other tracked *.log / *-latest.md) - `git rm --cached` + gitignore.
2. Any `.bak`, `creds.env`, `.env`, `*.key`, `*.pem`, `ops/backups/` - already gitignored (verified).
3. `docker-compose.override.yml` + `wazuh_manager.conf` live-key modification in
   `/opt/wazuh-docker/multi-node` - **separate repo (public wazuh/wazuh-docker origin)**; must
   NOT be committed there (see Phase 21.04).

## Secret risk (pre-cleanup)

- `ops/scripts/endpoint-count-report.sh`, `client013-baseline-report.sh`,
  `capacity-threshold-check.sh` contain hardcoded credential defaults (Phase 20 finding) -
  **must be remediated before commit** (Phase 21.04).
- `wazuh_manager.conf` (wazuh-docker repo, tracked file, local mod) carries a live VirusTotal
  API key - high push-leak risk; remediate with skip-worktree + rotation note.

## Decision

- Do NOT commit until: credential cleanup (04) + local CI pass + secret scan clean (03).
- Commit plan: see `ops/reports/phase21-commit-plan.md`.

## No secrets