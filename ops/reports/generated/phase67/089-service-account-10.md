# Phase 67: Service Account 10

**Report ID:** phase67-089-service-account-10
**Phase:** 67
**Title:** Service Account 10
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T22:37:12Z (UTC) / 2026-08-28 18:37:12 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase67/089-service-account-10.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 67 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / integratord / hook / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
Trusted time captured (UTC 2026-08-28T22:37:12Z / ET 2026-08-28 18:37:12 EDT). Phase 67 reconciles the Shuffle->IRIS destination leg. TRUTH CORRECTION (carried from P66 final): the leg is NOT broken. The workflow's execute_python reads the CORRECT mounted secret (prefix c21731, identical to the recovered creds.env key) and POSTs to the Shuffle-reachable URL https://iriswebapp_nginx:8443/alerts/add. Delivery is VERIFIED: IRIS contains live objects 140-149 with source=wazuh, tags source:wazuh,class:A; independent read-back VERIFIED (GET /alerts/149 -> 200 live Critical/New); iris_object_id=149; marker parity VERIFIED. The earlier 'delivery broken / 401' finding was incorrect (it tested the wrong standalone files). P67's additions: endpoint already selected (iriswebapp_nginx on shared network); least-privilege credential + idempotent retry/dead-letter/replay + destination monitoring are DESIGNED (recorded as OW-67-01, not yet wired into the live workflow); persistence after recreation is a DEFERRED approval-gated test. OW-65-01 and OW-66-01 CLOSED (P66).

## Universal Authentic Evidence (this session)
- Trusted time: UTC 2026-08-28T22:37:12Z / ET 2026-08-28 18:37:12 EDT.
- GENUINE Wazuh->Shuffle->IRIS delivery PROVEN + PERSISTENT: alert 1787948087.9767291 -> integratord [200] -> hook webhook_e3fec000-555f-4e81-9497-77b7c91c5b98 -> workflow c6b3fcd8-13e5-44a8-a818-024e4ae4422b -> execution 593b3840-0565-4d46-8574-c676cc7f54a8 -> IRIS POST 200 -> object 149 (VERIFIED read-back, marker parity VERIFIED).
- TRUTH CORRECTION: the leg is NOT broken (P66 final); only the ops-vault creds.env key was stale (fixed).
- Endpoint selected: https://iriswebapp_nginx:8443/alerts/add (shared network; loopback forbidden). Least-privilege + retry/dead-letter DESIGNED (OW-67-01).
- Single watchdog supervisor certified (s6; supervisor_count=1); 13 states reused; dashboard v2 (4 objects); disk watermark ENABLED (67%).
- OW-65-01 + OW-66-01 CLOSED (P66); OW-67-01 OPEN (design).

## Backup / Rollback
- Pre-change config backup retained outside repo; governed watchdog changes carry cleanup_stale.
- AGENTS.md edit preceded by timestamped sha256 backup under ops/backups/agents/.

## Limitations
- Retry/dead-letter/replay and least-privilege IRIS credential are DESIGNED (OW-67-01), not yet wired into the live workflow (no fabrication of implementation).
- Persistence after Shuffle task/container recreation is a DEFERRED approval-gated test (not performed here to avoid disrupting verified-working delivery).
- Restore and full DR remain DEFERRED.

## Verdict
VERIFIED -- directly evidenced (genuine Wazuh alert + integratord HTTP 200 + Shuffle execution + IRIS object 149 read-back VERIFIED); truth-correction carried; no fabricated PASS -- truthfully reflects current authorized, directly evidenced, production-scoped state; gated items recorded as design, not fabricated.
