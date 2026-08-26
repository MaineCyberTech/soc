# Phase 28 Consolidation Remediation Plan

Date: 2026-08-24
Status: **BACKLOG DEFINED** (prioritized; drives Phase 29 + release gates).

## P0 (must fix before v1.3.0)

| # | Item | Evidence | Action |
|---|---|---|---|
| 1 | Guardrail exec bit lost (100644) | cron down ~40h (phase 28 finding) | **DONE this phase** (chmod +x + index 100755) |
| 2 | 2 scripts embed fallback literal password | client013-baseline-report.sh, endpoint-count-report.sh | fail-closed (require WAZUH_WUI_PASSWORD; drop default) |
| 3 | Mutable image tags in production | shuffle/tenzir/opencanary/syslog-ng/cloudflared `latest`/`main` | pin resolved image IDs; add to dependency-lock + bundle manifest |

## P1 (high)

| # | Item | Action |
|---|---|---|
| 4 | Duplicate scorecard/alert-quality scripts (identical) | redirect ops/scripts copies -> reporting/generators; deprecate |
| 5 | Duplicate sysmon-mct.xml (stale in endpoint-deploy) | canonical integrations/sysmon; installer references fixed or copy removed |
| 6 | 7 committed __pycache__/*.pyc | git rm --cached + gitignore (already covered) |
| 7 | PVE222 token (401) + VT key replacement | operator supplies replacements (51/49) |
| 8 | Redis 120537 10K/day flood (owner) | portal VPS owner remediation (55) |

## P2 (medium / backlog)

| # | Item | Action |
|---|---|---|
| 9 | Cache refresh (Sysmon not cached; manifest 08-16) | refresh manifest + cache Sysmon zip (EULA cache-only) |
| 10 | Consolidated LICENSES/THIRD-PARTY notice | add repo root notice (43) |
| 11 | evidence/reports legacy duplication | mark deprecated; canonical = ops/reports |
| 12 | Hardcoded path/IP parametrization | profiles vars (35) applied across scripts |
| 13 | Fresh-target runtime drill | operator allocates isolated target (47) |

## Release gating

- P0 items block v1.3.0 (deployability certificate 63 requires P0 closed).

## No secrets