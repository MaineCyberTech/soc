# Phase 15 Repo Structure Audit

Date: 2026-08-16

## Status: SOUND - minor doc annotations made

## Structure

| Area | Purpose | Size | Verdict |
|---|---|---|---|
| Root docs | README, ARCHITECTURE, PORTS, PORTABILITY, SECURITY, REPO-MAP, RELEASE-NOTES | - | CURRENT (modified 08-16) |
| compose/ | 7 compose files (IRIS, MISP, Greenbone, Shuffle, OpenCanary, Velociraptor-deprecated) | 40K | velociraptor compose deprecated (native server) |
| scripts/ | bootstrap, verify, CI, endpoint-deploy | 180K | healthy |
| ops/ | runbooks, scripts, reports, checklists, cron | 4.4G (mostly backups) | backups gitignored |
| integrations/ | 10 subsystems | 948K | current |
| evidence/ | 122 historical reports + banner policy | 604K | properly separated |
| reporting/ | generators, templates, output | 312K | current |
| client-onboarding/ + service-packaging/ | MSP materials | 292K | current |
| data/ | vendored/live configs (velociraptor, opencanary) | 80M | gitignored |

## Findings

1. Velociraptor server runs NATIVE (not compose) - runbook annotated with
   source-of-truth note; compose marked deprecated.
2. 514 refs = historical change-log records (correct provenance, not stale).
3. Duplicate basenames = evidence/ historical reports (intended).
4. No live operational dependency exists ONLY in old phase packs.

## Actions

- [x] velociraptor runbook annotated
- [ ] (backlog) mark compose/docker-compose.velociraptor.yml as deprecated in header

## No secrets
