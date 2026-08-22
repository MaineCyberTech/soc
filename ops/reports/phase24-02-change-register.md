# Phase 24 Change Register and Gates

Date: 2026-08-22

| # | Change | Owner | Approval | Backup | Rollback | Health gate | Evidence |
|---|---|---|---|---|---|---|---|
| C1 | 014 + 013 Sysmon include-oriented tuning apply | Operator (endpoint access) | PENDING | config export + hash | reload prior config | EID1/10 continuity + buffer clean | before/after EID7 |
| C2 | 015 24h closeout | SOC | n/a (validate) | - | - | keepalive + volume + queue | 24h metrics |
| C3 | Zeek Class A routing enable | SOC + operator | PENDING | workflow export | disable filter | case volume < 5/day | case window |
| C4 | VT key rotation | Operator | PENDING (key) | manager conf backup | restore prior | VT integration fires | rotation record |
| C5 | Indexer password rotation | SOC | PENDING | .env/creds backup | restore + recreate | cluster/dashboard/scripts | post-rotation validation |
| C6 | PVE222 token refresh | Operator | PENDING (token) | creds backup | remove token | API 200 | healthcheck PASS |
| C7 | Evidence archive P11-P23 finals | SOC | APPROVED (doc) | hashes before | git revert | CI PASS | hash manifest |
| C8 | CI/governance hardening (health exits, scanner exclusions, shellcheck, brand, fixtures, REPO-MAP, checklists, headers) | SOC | APPROVED (code/docs) | git history | git revert | CI + secret PASS | commit |
| C9 | v1.2.0 release | Operator | PENDING | git tag | delete tag | release gates (40) | release object + asset |

## Rules

- Every destructive/service-affecting step: dry-run, backup, approval, rollback, validation.
- No client Greenbone scan without signed auth; no broad routing; no EID7 global disable.
- Evidence archive: copy-only, originals untouched, hashes recorded.

## Files
- `ops/reports/phase24-02-change-register.md` (this)

## No secrets