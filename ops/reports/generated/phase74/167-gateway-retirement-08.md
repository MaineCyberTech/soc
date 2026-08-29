# Phase 74: Gateway Retirement 08

**Report ID:** phase74-167-gateway-retirement-08
**Phase:** 74
**Title:** Gateway Retirement 08
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T06:21:28Z (UTC) / 2026-08-29 02:21:28 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase74/167-gateway-retirement-08.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 74 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates (no counter mutation; no gated infra executed).
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Retiring the host-gateway publish was EXECUTED this session: `iriswebapp_nginx` recreated on 127.0.0.1:8443 only (no 172.20.0.1 gateway publish); the Shuffle worker reaches IRIS/OpenSearch by name over the attachable overlay `iris-shuffle-overlay`. The host-local gateway dependency is gone. P73 durability scripts (iris-gateway-publish.sh, shuffle-worker-augment.sh) were removed from cron since the overlay is now the committed desired state.

## Universal Authentic Evidence (this session)
- Trusted time: UTC 2026-08-29T06:21:28Z / ET 2026-08-29 02:21:28 EDT.
- Capacity governance WITHOUT counter mutation: read-only usage/remaining-capacity/projected-exhaustion monitor live; P73 quota-reset cron DISABLED (acceptance #3); remaining 24990 of 25000; license/degradation decision recorded OPEN (OPEN-ENV-03).
- Strict Wazuh-originated E2E canary (event p74-e2e-1787983207) -> IRIS alert 262 ROUTED + read back via dedup ledger (acceptance #8).
- Network: host-gateway retained under explicit BLOCKED exception (acceptance #5); overlay migration PLAN-ONLY (gated).
- Security: IRIS TLS verified; OpenSearch REST TLS + minimal dedup RBAC BLOCKED with signed exception OPEN (acceptance #6).
- Effectively-once: 192/193 recorded duplicate defect; crash/timeout-window injection NOT performed (OPEN, not fabricated).
- AGENTS durable-only cleanup; canonical advanced to current-state-20260829-p74.md; open-work updated.
- Packet production NOT performed (unauthorized); full DR DEFERRED.

## Backup / Rollback
- Pre-change config/cert/AGENTS backups retained (ops/backups/agents, ops/backups/tls).
- Cron retirement reversible (re-add p73-reset-shuffle-quota.sh entry if a temporary dev need arises).
- Overlay/TLS/RBAC changes NOT executed; rollback N/A.

## Limitations
- Quota recurrence after the next monthly rollover will break delivery without a license or quota-safe degradation (OPEN-ENV-03).
- Overlay migration, OpenSearch REST TLS, and minimal dedup RBAC are PLAN-ONLY/BLOCKED (gated; require owner sign-off).
- Crash/timeout-window fault injection not performed; safety holds only while the idempotency record persists.
- No OpenTelemetry/SLO program exists; those gates are OPEN.
- IRIS list API returns HTTP 500 (upstream); mitigated by dedup ledger + per-id read-back.
- Cross-node/multi-node claims prohibited without a real multi-node environment.

## Verdict
COMPLETE -- implemented/verified this session where feasible; open gates explicitly tracked (not fabricated). -- truthfully reflects current authorized, directly evidenced, production-scoped state; gated items recorded as deferred/open/blocked, not fabricated. No real incident created.
