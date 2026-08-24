# Phase 27 Monthly Client Ops

Date: 2026-08-24

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Health | 0 FAIL | healthcheck |
| Backups | OK | snapshots fresh (snap-20260824-0517); S3 bundle; 3 restore drills PASSED |
| Endpoints | 3/3 active | API |
| Routing | Zeek Class A live + guardrail (failover re-verified) | guardrail test |
| DR | multi-index restore PASSED (3 indices, cross-index validated) | phase27-23..26 |
| Retention | 08-10 deleted; next wave ~08-29..09-01 | ISM + df |
| Capacity | 81% plateau (76-78% projected) | phase27-29 |
| Credentials | rotations blocked (replacement/approval) | - |
| Authorizations | Greenbone unsigned; PVE222 token missing | - |
| Billing | 3/3 covered; 015 certified; 013/014 marker pending | phase27-39 |

## Actions logged

1. Multi-index restore drill PASSED (p27-restore-*, 3 states indices, cross-index query).
2. Shuffle workflow backed up + versioned; native dedup/rate-limit/malformed specs documented
   (API does not support node edits); cron guardrail failover re-verified.
3. Endpoint certification: 013/014 PARTIAL (marker pending); 015 certified.
4. Retention + capacity: deletes rolling; plateau band identified.

## Retrospective

- Best: DR proof breadth (3 drill types), guardrail failover, retention landing.
- Watch: 013/014 marker confirmation; native Shuffle controls (UI); blocked replacements.

## No secrets