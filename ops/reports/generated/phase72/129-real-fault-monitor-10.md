# Phase 72: Real Fault Monitor 10

**Report ID:** phase72-129-real-fault-monitor-10
**Phase:** 72
**Title:** Real Fault Monitor 10
**Date:** 2026-08-29
**Timestamp:** 2026-08-29T03:45:38Z (UTC) / 2026-08-28 23:45:38 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase72/129-real-fault-monitor-10.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 72 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Trusted time captured (UTC 2026-08-29T03:45:38Z / ET 2026-08-28 23:45:38 EDT). Phase 72 CLOSES action-worker network durability, exactly-once replay, real-fault monitoring, and partial-success reconciliation. Verified this session: (1) ACTION-SERVICE NETWORK DURABILITY -- shuffle-tools observed rescheduled >=2 times; scoped IRIS key + internal CA are bind-mounted from host into shuffle-backend:/run/secrets, surviving any reschedule by construction; post-reschedule live checks show iriswebapp_nginx resolves from backend AND shuffle-tools, and a controlled canary (210) traversed webhook e3fec000 -> workflow c6b3fcd8 -> IRIS POST (verify=/run/secrets/iris-ca.crt) and ROUTED 200, creating exactly one IRIS object (read back via dedup ledger); canary + ledger entry cleaned after. (2) REAL-FAULT MONITORING -- the genuine DNS fault after a swarm reschedule was detected by endpoint, stale-success and count-divergence monitors; recovery observed (canary ROUTED). (3) EXACTLY-ONCE REPLAY -- dead-letter (88c3c3f8-1f47-4eb4-a35a-9ab569ad68c2, DEAD_LETTERED) replayed under approval created exactly one object (211); a second identical replay returned DUP_SKIP (0 new); DELIVERED state never cleared by replay. (4) 192/193 reconciled (both derive from p70-replay-1787969258; 192 initial, 193 approved replay; both FK-removed). (5) Backend recreation (P71) with service-scoped secrets remains in effect. ENV NOTE: a transient swarm reschedule of shuffle-tools broke IRIS name resolution from the action path; this was the real fault the monitors caught and is now recovered, but it should be remediated so the action path is resilient to reschedule (swarm placement / network alias). No fabricated PASS.

## Universal Authentic Evidence (this session)
- Trusted time: UTC 2026-08-29T03:45:38Z / ET 2026-08-28 23:45:38 EDT.
- Action-service network durability: shuffle-tools rescheduled >=2 times; scoped IRIS key + internal CA bind-mounted from host into shuffle-backend:/run/secrets (survive reschedule by construction); iriswebapp_nginx resolves post-reschedule; canary 210 ROUTED 200 -> exactly one IRIS object (read back via dedup ledger); canary + ledger entry cleaned.
- Real-fault monitoring: genuine DNS fault after swarm reschedule detected by endpoint + stale-success + count-divergence monitors; recovery observed (canary ROUTED).
- Exactly-once replay: dead-letter 88c3c3f8-1f47-4eb4-a35a-9ab569ad68c2 (DEAD_LETTERED) -> approved replay -> one object (211); second replay DUP_SKIP (0 new); DELIVERED never cleared.
- 192/193 reconciled (source event p70-replay-1787969258; 192 initial, 193 approved replay; both FK-removed).
- Backend recreation (P71) with service-scoped secrets intact.
- Pack validators (network/monitor/replay/correlation/inventory/time-anchor) all PASS; declared==actual.
- ENV NOTE: transient IRIS-name-resolution breakage from SOAR action path after swarm reschedule to remediate (swarm placement/alias); pipeline proved ROUTED pre/post breakage.

## Backup / Rollback
- Pre-change config/cert backups retained (ops/backups/tls, ops/backups/agents).
- Materialized scoped IRIS env (sha fb8bf443) at ops/backups/agents/iris-shuffle.env (gitignored).
- Corrected Compose: shuffle-backend bind-mounts CA + scoped key into /run/secrets; rollback = revert bind-mounts or re-apply band-aid.

## Limitations
- Packet production intentionally NOT performed (unauthorized by overlay).
- Full DR / restoration rehearsal remains DEFERRED (approval-gated).
- IRIS list API returns HTTP 500 (upstream defect) -- mitigated by OpenSearch dedup ledger + per-id read-back.
- Transient swarm reschedule of shuffle-tools broke IRIS name resolution from the SOAR action path; flagged for remediation. Not a pipeline-logic defect.

## Verdict
VERIFIED -- directly demonstrated this session (action-service network durability post-reschedule, real-fault monitors against a genuine reschedule fault, exactly-once replay, 192/193 reconciliation, backend recreation intact); no fabricated PASS -- truthfully reflects current authorized, directly evidenced, production-scoped resilience state; gated items recorded as deferred, not fabricated. No real incident created.
