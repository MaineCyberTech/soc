# Phase 21 Commit Plan

Date: 2026-08-19
Status: PLAN - execution gated on Phase 21.03 (CI + secret scan) and Phase 21.04 (credential cleanup) passing.

## Preconditions

1. Phase 21.04 credential cleanup merged (3 scripts + wazuh-docker repo safeguards).
2. Local CI passes (after Phase 21.05 false-PASS fix).
3. Secret scan clean (no hardcoded credential values in to-be-committed files).
4. Tracked log files untracked (below).

## Commit sequence (logical, one area per commit)

| # | Commit message (style: P21.<n>: <area>) | Files |
|---|---|---|
| 1 | `ops: untrack operational log files that dirty git status` | `git rm --cached` on backup-cron.log, backup-log.txt, backup-prune-cron.log, iris-db-cron.log, misp-cdb-cron.log, phase5-freshness-cron.log, shuffle-boot-repair.log, shuffle-export-cron.log, vm103-misp-cron.log, full-stack-health-latest.md; extend .gitignore |
| 2 | `integrations: phase19-20 packet/flow/macos/syslog docs + zeek rules v2.2` | integrations/*/phase19-*.md, phase20-*.md, phase19-zeek-custom-rules-v2.xml |
| 3 | `reports: phase19 operator deliverables` | ops/reports/phase19-*.md, final-phase19-operator-report |
| 4 | `reports: phase20 audit and operator deliverables` | ops/reports/phase20-*.md, final-phase20-operator-report, proxmox-thinpool-report |
| 5 | `ops+docs: index retention runbook, billing readiness, scan auth status` | ops/runbooks/index-retention-policy.md, service-packaging/phase20-billing-readiness.md, client-onboarding/phase19-client-scan-authorization-status.md |
| 6 | (Phase 21 close) `reports: phase21 deliverables + final report` | phase21-*.md at close |

## Exclusions (never staged)

- creds.env, .env, ops/backups/, *.bak, *.key, *.pem, *.tar.gz, __pycache__/, *.pyc
- Any file still containing a credential value (secret scan gate).

## Verification before each commit

- `git diff --cached` review; `git status` confirms no secrets; secret-pattern-scan on staged files.

## Post-commit

- Push + tag v1.1.0 only after Phase 21.06 release checklist (approval-gated).

## No secrets