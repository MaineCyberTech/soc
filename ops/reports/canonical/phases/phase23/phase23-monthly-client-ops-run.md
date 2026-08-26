# Phase 23 Monthly Client Ops Run

Date: 2026-08-22

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Stack health | 0 FAIL | healthcheck 20260822-045817 |
| Backups | OK | snap <24h, S3 <48h, config <48h |
| Endpoint coverage | 2/3 (014 degraded, 015 restored, 013 offline) | API + telemetry |
| Alerts | Zeek ~316/day clean; 014 throttled; 015 bounded | indexer |
| Routing | Class A approval-pending (not enabled) | change register C3 |
| Capacity | disk 83% (relief applied 2.8GB), swap 8.6% (resolved) | df/vmstat |
| Credentials | env-abstraction in place; rotations pending (VT key, indexer) | - |
| Authorizations | Greenbone unsigned; PVE222 token missing | - |
| Scorecard | draft (internal) | phase23-scorecard-progress |
| Billing | PARTIAL (015 restored) | phase23-billing-readiness |

## Actions logged

1. 015 reconnect validated (bounded telemetry; archives 0; 0 queue-full) - 24h window accruing.
2. Disk relief D1+D2 applied (85% -> 83%), cluster green.
3. Swap root-cause documented (transient flood pressure; now idle pages, si=0).
4. Evidence banners applied 122/122 (claim now true).
5. Docs refreshed (ARCHITECTURE, STACK-OVERVIEW header); client-dir classification + moves.
6. EventID7 include-oriented design review (Sysmon) - apply blocked.
7. Change register + approval gates created.

## Retrospective

- Positive: 015 recovery (external apply) + disk relief + swap resolution + evidence truth.
- Blocked: 014/013 endpoints (access), PVE222 token, VT key, indexer rotation, NetFlow scope.

## No secrets