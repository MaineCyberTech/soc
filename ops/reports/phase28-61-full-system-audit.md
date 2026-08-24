# Phase 28 Full System Regression Audit

Date: 2026-08-24

## Post-change state (vs P27)

| Area | P27 | P28 | Regression |
|---|---|---|---|
| Healthcheck | 0 FAIL | 0 FAIL | NO |
| CI / secret | PASS | PASS | NO |
| Cluster | green | green (264 shards) | NO |
| Fleet | 3/3 | 3/3 coverage (013/015 transient offline) | NO (coverage) |
| Guardrail | active | **restored** (was down ~40h; +x restored, index 100755) | NO (fixed) |
| DR | multi-index drill PASSED | full-cluster architecture + runbook; NO-GO (no target) | NO |
| Retention | 08-10 deleted | next wave 08-15..18 (~08-29..09-01) | NO |
| Capacity | 81% | 81% plateau (76-78% projected) | NO |
| Shuffle | backed up; UI pending | UI still approval-pending; cron failover re-validated | NO |
| Consolidation | n/a | audits + remediation started (P0 partial) | NEW |

## Findings this phase

1. Guardrail exec bit lost (cron down ~40h) - FIXED (P0).
2. 7 tracked pycache removed; password-fallback confirmed already fixed in live scripts.
3. Mutable image tags (8) - locked in dependency-lock.json; pinning in bundle gate.
4. 013/015 transient offline (not coverage failure).

## Risk register (updated)

- 013/014 marker pending; Shuffle UI approval; mutable tags; full-cluster drill target;
  release approval; Redis 120537 owner.

## Verdict

- **No regressions**; one operational incident (guardrail) found and closed.

## No secrets