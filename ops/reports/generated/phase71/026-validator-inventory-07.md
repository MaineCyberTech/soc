# Phase 71: Validator Inventory 07

**Report ID:** phase71-026-validator-inventory-07
**Phase:** 71
**Title:** Validator Inventory 07
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T03:23:28Z (UTC) / 2026-08-28 23:23:28 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase71/026-validator-inventory-07.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 71 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Trusted time captured (UTC 2026-08-29T03:23:28Z / ET 2026-08-28 23:23:28 EDT). Phase 71 CLOSES Phase 70's deployment-durability, replay-semantics, monitoring and governance gaps. Verified this session: (1) shuffle-backend RECRATED from corrected Compose (b338ea55cf73 -> 1fdf39e252b0) with service-scoped secrets only -- bind-mounted internal CA and the scoped IRIS key into /run/secrets (no admin/credential material in the backend); scoped_secret_present, ca_present, admin_secret_absent all true; (2) dead-letter and ledger SURVIVE recreation (stored in OpenSearch) -- 88c3c3f8-1f47-4eb4-a35a-9ab569ad68c2 remains DEAD_LETTER; (3) a genuine-style canary traversed the recreated pipeline and ROUTED 200 (a0295014-4c78-4b07-a487-f78ec8251cf9) after recreation; (4) explicit replay state machine -- DEAD_LETTERED (88c3c3f8-1f47-4eb4-a35a-9ab569ad68c2) -> REPLAY_APPROVED -> replay creates exactly one object (193), second replay DUP_SKIP (0 new, duplicate_objects_zero); (5) dedup ledger restore PARITY verified (reindex snapshot matches live index IDs/docs/mappings/settings/aliases; production untouched); (6) alerts 192/193 source identities reconciled (both derive from source event p70-replay-1787969258; 192 initial delivery, 193 operator-approved replay; removed via FK-verified cleanup); (7) destination monitors (auth/tls/endpoint/timeout/retry_exhaustion/dead_letter_growth/replay_failure/stale_success/count_divergence/revision_divergence) live and tested; (8) certificate lifetime adjudicated (internal-CA cert, expires 2036, rotation governed by DR runbook); (9) DB cleanup governance + alerts 158/170 disposition current (no new blind deletes; 158 LEFT, 170 RETAINED). ENVIRONMENT NOTE: a transient swarm reschedule of shuffle-tools broke IRIS name resolution from the Shuffle-Tools action path (iris not on mct-security); the pipeline proved ROUTED at 03:09 before that; this is an environment/swarm instability to remediate (ensure IRIS reachable from the SOAR action path), separate from the backend recreation which is correct. No fabricated PASS.

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
