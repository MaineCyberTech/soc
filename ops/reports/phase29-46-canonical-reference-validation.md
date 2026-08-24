# Phase 29 Canonical Reference Validation

Date: 2026-08-24

## Stale-path search results

| Pattern | Hits | Verdict |
|---|---|---|
| `ops/scripts/generate-*.py` (cron/runbooks) | reporting-automation.md:19-24,55 + scorecard-delivery.md | CANONICAL (matches ops/scripts) - corrected in 45 |
| `reporting/generators/generate-*.py` callers | **none** | duplicate deprecated |
| `sysmon-mct.xml` references | runbooks + integrations/sysmon docs -> integrations/sysmon | CANONICAL; endpoint-deploy copy stale |
| `data/dfir-iris` (nested git) | deploy copy | canonical = upstream v2.4.29 (33) |
| `.env`/creds refs | all via ${VAR} | canonical env abstraction |

## Verification

- Every live caller (cron, runbooks, installers, CI) references the canonical path per the
  updated canonical-source-map (33). Drift between running config and repo canonical
  (wazuh_manager.conf skip-worktree) is intentional (guardrail toggle), reconciled at install.

## Result

- **PASS** with the 45 correction recorded (scorecard generators canonical = ops/scripts/).

## No secrets