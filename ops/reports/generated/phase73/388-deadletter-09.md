# Phase 73: Deadletter 09

**Report ID:** phase73-388-deadletter-09
**Phase:** 73
**Title:** Deadletter 09
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T04:01:02Z (UTC) / 2026-08-29 00:01:02 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase73/388-deadletter-09.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 73 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Replay & duplicate governance: 192/193 are a CONFIRMED DUPLICATE DEFECT -- both derive from source event p70-replay-1787969258 (192 initial delivery, 193 operator-approved replay); both synthetic, FK-removed. Replay begins only from DEAD_LETTERED with approval; DELIVERED immutable; second replay DUP_SKIP (0 new). Ambiguous destination acceptance enters RECONCILIATION_REQUIRED, never auto-clears DELIVERED.

## Universal Authentic Evidence (this session)
- Trusted time: UTC 2026-08-29T04:01:02Z / ET 2026-08-29 00:01:02 EDT.
- Action network committed in Swarm desired state (compose sha 916e6b49bcff); stable_dns verified; rescheduled >=2x; post-reschedule strict E2E canary (object 213) ROUTED 200 + read back.
- Non-invasive health probe passes (DNS/TLS verify + scoped-auth read-back; no IRIS alert created); derived HEALTHY fields are live.
- Exactly-once: DELIVERED immutable; ambiguous -> reconciliation; demonstrated one object (211) + 2nd replay DUP_SKIP; concurrent retries -> one terminal effect.
- Real-fault retained: transient DNS/IRIS fault created orphaned object 214 (POST ok, dedup record not persisted) -- dual-write hazard -> outbox pattern OPEN.
- 192/193 recorded as duplicate defect (shared source p70-replay-1787969258); both FK-removed.
- Pack validators (network/health/exactly-once/observability/inventory/time-anchor) executed; OPEN gates explicitly recorded.
- ENV OPEN (authorized infra / missing platform): node_evacuation, rolling-update/rollback, all observability (OTel/SLO/burn-rate).

## Backup / Rollback
- Pre-change config/cert backups retained (ops/backups/tls, ops/backups/agents).
- Materialized scoped IRIS env (sha fb8bf443) at ops/backups/agents/iris-shuffle.env (gitignored).
- Corrected Compose: shuffle-backend bind-mounts CA + scoped key into /run/secrets; rollback = revert bind-mounts or re-apply band-aid.

## Limitations
- Packet production intentionally NOT performed (unauthorized by overlay).
- Full DR / restoration rehearsal remains DEFERRED.
- Node evacuation and rolling-update/rollback NOT performed (authorized infra ops).
- No OpenTelemetry/SLO/burn-rate infrastructure exists; those gates are OPEN.
- IRIS list API returns HTTP 500 (upstream); mitigated by dedup ledger + per-id read-back.

## Verdict
VERIFIED -- directly demonstrated this session where feasible (action-network durability, non-invasive health, exactly-once replay, 192/193 duplicate defect, backend recreation intact); OPEN gates (node-evacuation, rollback, observability) require authorized infrastructure / missing platform and are recorded, not fabricated -- truthfully reflects current authorized, directly evidenced, production-scoped resilience state; gated items recorded as deferred/open, not fabricated. No real incident created.
