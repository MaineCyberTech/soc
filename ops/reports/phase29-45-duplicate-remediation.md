# Phase 29 Duplicate Remediation

Date: 2026-08-24
Status: **CANONICAL CORRECTED; DEPRECATION DOCUMENTED** (no source deleted - safety).

## Duplicates addressed

| Duplicate | Canonical (corrected) | Action |
|---|---|---|
| generate-alert-quality-report.py / generate-monthly-scorecard.py | **ops/scripts/** (runbooks + cron call this path) | P28 map said reporting/generators - **CORRECTED**; reporting/generators copies deprecated (no callers) |
| sysmon-mct.xml | integrations/sysmon/ (runbooks + deployment docs reference it) | scripts/endpoint-deploy copy deprecated (stale; installer embeds its own) |
| evidence/reports/ legacy | ops/reports/ | deprecated historical subset (P28) |

## Corrections applied

- ops/reports/phase28-33-canonical-source-map.md updated: scorecard generators canonical =
  ops/scripts/.
- reporting/generators/ documented as deprecated (identical copies, zero callers) - retained
  as historical evidence, removal deferred (rollback-safe).

## Compatibility wrappers

- Not required: canonical path already matches all live callers (runbooks, cron, installer).

## No secrets