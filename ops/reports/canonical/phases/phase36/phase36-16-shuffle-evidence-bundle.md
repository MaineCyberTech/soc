# Phase 36: Shuffle Evidence Bundle

Date: 2026-08-25

## Evidence collected

| # | Evidence | Source | Status |
|---|---|---|---|
| E1 | Workflow list (2 workflows) | API GET /api/v1/workflows | CAPTURED |
| E2 | Workflow details | API GET /api/v1/workflows/{id} | CAPTURED |
| E3 | Backend health | docker logs + status | HEALTHY |
| E4 | Execution history | OpenSearch workflowexecution-000001 | 796 records |
| E5 | User record | OpenSearch users index | soc@mainecybertech.com |
| E6 | Org record | OpenSearch organizations index | mct-soc |

## Auth status
- API Bearer: WORKS
- Username login: BROKEN (password unknown)

## Workflow routing
- Wazuh → Shuffle: NOT CONFIGURED
- Shuffle → IRIS: CONFIGURED (notify-only)

## No secrets
