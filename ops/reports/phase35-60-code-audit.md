# Phase 35: Codebase Regression Audit

Date: 2026-08-25

## Scripts audit

| Script | Permissions | Status |
|---|---|---|
| p33-alert-runner.sh | 775 | HEALTHY |
| p33-core-alert.sh | 775 | HEALTHY (cron every 15min) |
| p33-observe-snapshot.sh | 775 | HEALTHY |
| p33-release-provenance.sh | 775 | HEALTHY |
| p33-retention-evidence.sh | 775 | HEALTHY |
| p33-sid-summary.py | 775 | HEALTHY |
| p33-tmp-health.sh | 775 | HEALTHY |
| p34-alert-selftest.sh | 775 | HEALTHY |
| p34-canary-evidence.sh | 775 | HEALTHY |
| p34-retention-diff.py | 775 | HEALTHY |
| p34-tmp-trend.sh | 775 | HEALTHY |
| p34-zero-alert-integrity.sh | 775 | HEALTHY |
| p35-agent016-config-audit.sh | 775 | HEALTHY |
| p35-alert-state-audit.py | 775 | HEALTHY |
| p35-canary-manifest.sh | 775 | HEALTHY |
| p35-endpoint-state.py | 775 | HEALTHY |
| p35-index-diff.py | 775 | HEALTHY |
| p35-tmp-trend.sh | 775 | HEALTHY |

## CI
- verify.yml: present, last modified 2026-08-24
- CI status: PASS (no failures reported)

## Secrets
- No secrets in codebase (grep verified)
- creds.env not committed

## Duplicate/dead code
- No duplicate scripts detected
- No dead code in ops/scripts/

## Image pins
- Check passed in P34 (8 refs pinned)
- No new unpinned images since P34

## PASS — No regressions found
## No secrets
