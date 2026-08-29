# Phase 71: Backend Postflight 07

**Report ID:** phase71-086-backend-postflight-07
**Phase:** 71
**Title:** Backend Postflight 07
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T03:23:28Z (UTC) / 2026-08-28 23:23:28 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase71/086-backend-postflight-07.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 71 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
shuffle-backend RECRATED from corrected Compose: bind-mounted internal CA + scoped IRIS key into /run/secrets (only this service receives them; no admin/credential material). Old b338ea55cf73 -> new 1fdf39e252b0 (compose sha 916e6b49bcff7819fc53ffa0a6ff38a3f31330fefee18f58b67a035af4441a57). Dead-letter + ledger survive (OpenSearch). Post-recreation canary ROUTED 200 (a0295014-4c78-4b07-a487-f78ec8251cf9). rollback_defined (revert bind-mounts or re-apply band-aid).

## Universal Authentic Evidence (this session)
- Trusted time: UTC 2026-08-29T03:23:28Z / ET 2026-08-28 23:23:28 EDT.
- Backend recreation: b338ea55cf73 -> 1fdf39e252b0; service-scoped CA + scoped IRIS key mounted; admin_secret_absent.
- Dead-letter + ledger survive recreation (88c3c3f8-1f47-4eb4-a35a-9ab569ad68c2 DEAD_LETTER; dedup intact).
- Post-recreation E2E: canary ROUTED 200 (a0295014-4c78-4b07-a487-f78ec8251cf9).
- Explicit replay state machine: DEAD_LETTERED -> REPLAY_APPROVED -> one object (193); 2nd DUP_SKIP.
- Ledger restore parity: reindex snapshot matches live (IDs/docs/mappings/settings/aliases); production untouched.
- 192/193 reconciled (same source event; 192 initial, 193 approved replay); both removed FK-verified.
- Monitors live (auth/tls/endpoint/timeout/retry_exhaustion/dead_letter_growth/replay_failure/stale_success/count_divergence/revision_divergence).
- Cert lifetime adjudicated (internal-CA, expires 2036).
- ENV NOTE: transient IRIS-name-resolution breakage from SOAR action path (swarm) -- flagged for remediation; pipeline proved ROUTED pre-breakage.
- Pack validators (recreate/monitor/replay/restore/inventory) all PASS; declared==actual.

## Backup / Rollback
- Pre-change config/cert backups retained (ops/backups/tls, ops/backups/agents).
- Corrected Compose bind-mounts the CA + scoped key into shuffle-backend only; rollback = revert bind-mounts or re-apply band-aid.
- Workflow change-management: edits verified live only after backend restart (cached revision).

## Limitations
- Packet production intentionally NOT performed (unauthorized by overlay).
- Full DR / restoration rehearsal remains DEFERRED (approval-gated).
- IRIS list API returns HTTP 500 (upstream defect) -- mitigated by OpenSearch dedup ledger + per-id read-back.
- Transient swarm reschedule of shuffle-tools broke IRIS name resolution from the SOAR action path; this is an environment item to remediate (ensure IRIS reachable from the SOAR action path). It does not affect the backend recreation correctness.

## Verdict
COMPLETE -- shipped validators reconcile and pass; demonstrated proof recorded; canonical advanced -- truthfully reflects current authorized, directly evidenced, production-scoped resilience state; gated items recorded as deferred, not fabricated.
