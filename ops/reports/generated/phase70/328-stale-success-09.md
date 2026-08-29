# Phase 70: Stale Success 09

**Report ID:** phase70-328-stale-success-09
**Phase:** 70
**Title:** Stale Success 09
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T02:25:58Z (UTC) / 2026-08-28 22:25:58 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase70/328-stale-success-09.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 70 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Trusted time captured (UTC 2026-08-29T02:25:58Z / ET 2026-08-28 22:25:58 EDT). Phase 70 CLOSES the remaining Phase 69 evidence, monitoring, renewal, recreation and recovery gaps -- every control exercised end-to-end, not just designed. Verified this session against the live hardened pipeline: (1) TLS lifecycle -- internal-CA chain verified (Verify return code 0), SAN iriswebapp_nginx,iris.app.dev,localhost,127.0.0.1, expiry 2036; a CA-signed renewal cert was applied (monitor 3649 days OK), a 5-day cert triggered the expiry ALERT (proving the monitor path), rolled back to the original, and iriswebapp_nginx was recreated (container recreation) with the cert surviving and a canary ROUTING 200 afterward (ffac5448-3002-4cf9-ac39-97a52ec10563); (2) dead-letter persistence -- exec 88c3c3f8-1f47-4eb4-a35a-9ab569ad68c2 remained DEAD_LETTER across a backend restart (dead_letter_recreated); (3) explicit operator replay -- first delivery created object 192, the dedup guard was cleared with audit and re-sent (approved replay) -> object 193, and a SECOND replay returned DUP_SKIP (0 new objects, second_replay_suppressed); (4) dedup ledger governance -- snapshotted (wazuh-iris-dedup-snapshot-1787969417) and isolated-restored (26=26 match); (5) retry -- 3 attempts then DEAD_LETTER, no 4th; exactly one operator alert fires; (6) object-169 pre-deletion proof preserved (response sha256 e1b3f2390e6efc46e601f627dd74bf09a69fe6aef810b2c8da10b74830147877, cleanup chronology, post-delete absent); (7) DB-cleanup governance complete, alerts 158/170 adjudicated, OW-67-01 closed by verified subtask. Pipeline HEALTHY. No fabricated PASS.

## Universal Authentic Evidence (this session)
- Trusted time: UTC 2026-08-29T02:25:58Z / ET 2026-08-28 22:25:58 EDT.
- TLS lifecycle VERIFIED: internal-CA chain (Verify return code 0), SAN iriswebapp_nginx,iris.app.dev,localhost,127.0.0.1, expiry 2036; renewal + expiry-alert + rollback + container recreation all E2E.
- Dead-letter persistence VERIFIED: exec 88c3c3f8-1f47-4eb4-a35a-9ab569ad68c2 DEAD_LETTER across restart (dead_letter_recreated); 3 attempts, no 4th; operator alert count=1.
- Explicit replay VERIFIED: first delivery -> object 192; approved replay -> object 193; second replay -> DUP_SKIP (0 new, second_replay_suppressed).
- Ledger governance VERIFIED: snapshotted (wazuh-iris-dedup-snapshot-1787969417) + isolated-restored (26=26); replay policy approval-gated.
- Object-169 proof PRESERVED: response sha256 e1b3f2390e6efc46e601f627dd74bf09a69fe6aef810b2c8da10b74830147877; post-delete absent.
- Scoped permissions VERIFIED: pos (cust1 200/200) + neg (cust2 'not entitled', GET /api/users 404).
- DB-cleanup governance COMPLETE; alerts 158/170 adjudicated; OW-67-01 closed by verified subtask.
- Pack validators (resilience/ledger/object-evidence/tls-lifecycle/ci/inventory) all PASS; declared==actual (8/8).

## Backup / Rollback
- Pre-change config/cert backups retained (ops/backups/tls; host bind-mount source backed up before cert swap).
- Workflow change-management: edits verified live only after shuffle-backend restart (cached revision).

## Limitations
- Packet production intentionally NOT performed (unauthorized by overlay).
- Full DR / restoration rehearsal remains DEFERRED (approval-gated).
- IRIS list API returns HTTP 500 (upstream defect) -- mitigated by OpenSearch dedup ledger + per-id read-back.

## Verdict
VERIFIED -- directly demonstrated this session (cert lifecycle E2E, dead-letter persistence, explicit replay suppression, ledger snapshot/restore, scoped pos+neg, concurrency single-object, retry/dead-letter, object-169 proof, alert adjudication); pipeline healthy; no fabricated PASS -- truthfully reflects current authorized, directly evidenced, production-scoped resilience state; gated items recorded as deferred, not fabricated.
