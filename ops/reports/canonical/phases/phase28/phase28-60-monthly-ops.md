# Phase 28 Monthly Client Ops

Date: 2026-08-24

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Health | 0 FAIL | healthcheck |
| CI / secret | PASS / PASS | gates |
| Backups | OK | 42 snapshots (latest snap-20260824-1517); bundle 04:00 + S3 |
| Endpoints | 3/3 coverage; 013/015 transient offline at review | wazuh API |
| Routing | Zeek Class A live; **guardrail restored** (was down ~40h) | phase28-21 |
| DR | component drills PASSED; full-cluster NO-GO (no target) | phase28-23..28 |
| Capacity | 81% plateau; next delete wave ~08-29..09-01 | phase28-29/30 |
| Credentials | VT/PVE/indexer blocked (replacement/approval) | phase28-49..52 |
| Authorizations | Greenbone unsigned; NetFlow scope pending | phase28-53/56 |
| Consolidation | inventory/duplicate/canonical audits DONE; remediation P0 partially closed | phase28-31..48 |
| Billing | 3/3 coverage; 013/014 quality pending | phase28-58 |
| Release | v1.3.0 gates staged (approval-pending) | phase28-64..66 |

## Actions logged (this phase)

1. **Guardrail restored** (exec-bit lost -> cron down ~40h; chmod +x + git index 100755).
2. Consolidation audit stack executed (inventory, duplicate, canonical, dependency lock,
   config schema/profiles, secrets/network/storage, install DAG, clean-deploy, idempotency,
   offline/cache, licensing, smoke, upgrade/rollback, golden path, fresh-target dry-run,
   remediation plan).
3. New artifacts: config/dependency-lock.json, config/schema.json, config/service-graph.json,
   config/profiles/*.env.example; p28 tooling added to ops/scripts.
4. P0/P1 partial closure: guardrail exec bit, pycache untracked, password-fallback confirmed
   already fixed in live scripts.

## Retrospective

- Best: guardrail incident found+closed; consolidation depth; fresh-target gate caught a real
  path bug (CI script location).
- Watch: 013/015 offline (transient); marker confirmation; mutable image tags; native Shuffle
  controls (UI approval); release approval.

## No secrets