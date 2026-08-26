# Phase 25 Monthly Client Ops

Date: 2026-08-22

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Health | 0 FAIL | healthcheck |
| Backups | OK | snap 05:17 fresh; DR bundle uploading; **S3 restore drill PASS** |
| Endpoints | 3/3 active | API |
| Routing | **Zeek Class A ENABLED (approved)**; cases 0 | integration + workflow executions FINISHED |
| Capacity | disk 84% / node 84.7% (at low watermark); retention relief in motion | df/ISM |
| Credentials | rotations blocked (replacement/approval) | - |
| Authorizations | Greenbone unsigned; PVE222 token missing | - |
| Scorecard | draft (gates: 015 closeout + tuning confirm) | phase25-39 |
| Billing | 3/3 covered; quality pending tuning | phase25-38 |

## Actions logged

1. **Zeek Class A routing enabled** (approved): Wazuh integration rule_id 122001-122003 ->
   Shuffle webhook -> IRIS; synthetic tests FINISHED; kill switch documented.
2. **DR S3 restore drill executed + PASSED** (checksum match 4c00952d..., safe extract 82
   files, RTO 0.2s, RPO <= 24h).
3. **Retention aligned**: archives-14d attached to all archives indices (08-07..08-22);
   ~14.4GB relief projected.
4. v1.2.0 re-verified (published P24). P25 bundle staged.
5. Endpoint tuning: 014 policy accepted (rc=0); 013 re-apply pending operator run.

## Retrospective

- Best: routing enabled, DR proof completed, retention relief in motion.
- Watch: EID7 tuning confirmation, disk at watermark (relief coming), blocked replacements.

## No secrets