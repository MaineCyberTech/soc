# Phase 26 Monthly Client Ops

Date: 2026-08-23

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Health | 0 FAIL | healthcheck |
| Backups | OK | snapshots fresh; S3 bundle uploading; restore drills PASSED |
| Endpoints | 3/3 active | API |
| Routing | Zeek Class A enabled + **guardrailed** (kill switch proven) | guardrail script + tests |
| Retention | **deletes observed** (08-07/08/09 gone; disk 79.5%) | ISM + df |
| Credentials | rotations blocked (replacement/approval) | - |
| Authorizations | Greenbone unsigned; PVE222 token missing | - |
| Billing | 3/3 covered; quality pending 013/014 marker | phase26-37 |
| Scorecard | finalized (draft-final) | phase26-38 |

## Actions logged

1. Snapshot restore drill PASSED (p26-restore scratch, validated, cleaned up).
2. Zeek guardrail implemented (rate-limit 5/day + kill switch + cron) and kill switch tested.
3. 015 closeout PASSED. 013 reconnected (root cause: endpoint wake + retry).
4. Retention relief observed (84.7% -> 79.5% node).
5. Endpoint tuning: 013/014 confirmation pending operator check (EID7 already quiet).

## Retrospective

- Best: snapshot restore proof, kill-switch guardrail, retention relief landed.
- Watch: 013/014 marker confirmation; blocked replacements; NetFlow scope.

## No secrets