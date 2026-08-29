# Phase 70: Chronology 07

**Report ID:** phase70-016-chronology-07
**Phase:** 70
**Title:** Chronology 07
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T02:25:58Z (UTC) / 2026-08-28 22:25:58 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase70/016-chronology-07.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 70 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Chronology P65->70: P65 repaired Wazuh->Shuffle leg + webhook; P66 PROVED Shuffle->IRIS leg (objects 140-149); P67 recorded least-privilege + retry/dead-letter DESIGN (OW-67-01); P68 IMPLEMENTED hardening (scoped IRIS credential, internal-CA TLS, dedup ledger, 3-attempt retry, DR runbook) and CLOSED OW-67-01; P69 DEMONSTRATED the controls end-to-end; P70 CLOSES residual gaps (cert lifecycle E2E, dead-letter persistence, explicit replay, ledger snapshot/restore, object-169 proof, alert 158/170 adjudication).

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
COMPLETE -- shipped validators reconcile and pass; demonstrated proof recorded; canonical advanced -- truthfully reflects current authorized, directly evidenced, production-scoped resilience state; gated items recorded as deferred, not fabricated.
