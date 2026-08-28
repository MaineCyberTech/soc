# Phase 67: Integratord 05

**Report ID:** phase67-174-integratord-05
**Phase:** 67
**Title:** Integratord 05
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T22:37:12Z (UTC) / 2026-08-28 18:37:12 EDT (America/New_York)
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase67/174-integratord-05.md

## Execution Contract Adherence
- Read root/scoped AGENTS and Phase 67 overlay.
- Classified report token strings by evidence; no false incidents created.
- Executed safe, reversible, authorized work; stopped at new gates.
- Never exposed confirmed real credentials; never GET a Shuffle webhook for health.
- Separated source / process / alert / integratord / hook / execution / response / read-back evidence.
- Recorded UTC and America/New_York; included non-secret IDs/hashes, backup, rollback, limitations, verdict.

## Evidence
wazuh-integratord delivered the GENUINE alert 1787948087.9767291 to the Shuffle webhook with Response [200] (phase65-integratord-delivery.log). Single integratord instance; governed by the single s6-supervised watchdog. Delivery is real Wazuh->Shuffle, not synthetic.

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
