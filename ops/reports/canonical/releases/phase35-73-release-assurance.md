# Phase 35: v1.3.0 Release Assurance

Date: 2026-08-25

## Release status
- **v1.3.0**: PUBLISHED (tag 790968b8, release id 375979989)
- **Bundle SHA256**: da72bde4... (verified in P30)

## Release contents
- All P31-P33 scripts and reports
- Canary design (P34)
- Image pins (8 refs)
- CI workflow (verify.yml)

## Consistency checks
| Check | Status |
|---|---|
| Release tag | CONSISTENT |
| Bundle SHA256 | CONSISTENT |
| Scripts permissions | CONSISTENT (775) |
| Image pins | CONSISTENT (8 refs) |
| Config files | CONSISTENT |
| Rules | CONSISTENT |
| Alerts | CONSISTENT (86601, 5501, 5502) |
| Dashboards | CONSISTENT |
| Docs | CONSISTENT |
| Sensitive files | NOT COMMITTED |

## New P35 changes
- Reports only (no code changes)
- eve-alert.json forwarding applied to agent 016 (already in P34)
- No release needed for P35 reports

## Gate: CONSISTENT — no inconsistencies found
## No secrets
