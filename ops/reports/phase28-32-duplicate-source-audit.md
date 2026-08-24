# Phase 28 Duplicate Source Audit

Date: 2026-08-24
Source: p28-consolidation-candidates.sh (513 same-name pairs; most are .git hooks / README / report renames, noise removed below).

## True duplicates (actionable)

| Duplicate | Hash | Verdict |
|---|---|---|
| `generate-alert-quality-report.py` (ops/scripts + reporting/generators) | **IDENTICAL** | REDIRECT: canonical = reporting/generators; ops/scripts copy deprecated |
| `generate-monthly-scorecard.py` (ops/scripts + reporting/generators) | **IDENTICAL** | REDIRECT: canonical = reporting/generators |
| `sysmon-mct.xml` (integrations/sysmon vs scripts/endpoint-deploy) | DIVERGED | canonical = integrations/sysmon (managed); endpoint-deploy copy is stale - redirect installer to canonical or delete |
| `evidence/reports/` vs `ops/reports/` | PARTIAL overlap (135 vs 894 tracked) | legacy historical subset; mark deprecated; canonical = ops/reports |

## Complementary (NOT duplicates - retained)

| Pair | Reason |
|---|---|
| webhook-contracts/*.json vs test-events/*.json | contracts (schema) vs sample payloads - different purpose |
| ops/runbooks vs ops/reports | procedures vs evidence |

## Stale/phase variants (removal candidates)

- checklists/{dr-restore-test,dr-scratch-restore,phase4-pre-change,phase8-dr-restore}-checklist.md: deleted in working tree (pending commit) - superseded by phase runbooks.
- 7 committed `__pycache__/*.pyc`: stale build artifacts - untrack + remove.

## Runtime-only changes

- Wazuh running config vs repo canonical (wazuh_manager.conf.skip-worktree) - intentional (guardrail toggle).

## Verdict

- 4 real duplicate groups identified; redirect/remove plan in 48 (remediation).

## No secrets