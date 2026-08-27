# Phase 56: Status Adjudication

**Prompt:** 044-classa-status-adjudication
**Generated (UTC):** 2026-08-28T00:20:00Z
**Operator (EDT):** 2026-08-27T20:20:00-0400
**Verdict:** DONE

## Summary
Adjudicated the Class-A (`eb937a37` / `wazuh-high-severity-to-iris`) path across five states, kept
as separate layers. The workflow EXISTS and is CONFIGURED (status `test`), its embedded trigger
object claims `running`, but the trigger is NOT in the live Shuffle trigger registry (only
`suricata-eve-in` is registered). Requests can be formed and routed to `shuffle-backend` but hit a
webhook-id that has no live trigger. The IRIS DESTINATION is reachable but currently returns 401
(auth regression).

## Evidence (separate layers)
**REST / trigger layer**
- EV-ST-01 (VERIFIED): `GET /api/v1/triggers` returns exactly ONE webhook: `suricata-eve-in` (`736b7410`). Class-A trigger `24636c49-a2d0-40c2-887e-ccecdf22fc5c` is ABSENT from the live registry.
- EV-ST-02 (VERIFIED): Workflow `eb937a37` `status=test`; embedded trigger `24636c49` `status=running` (configured) — contradicts live registry. (configured vs registered mismatch.)

**Wazuh integratord layer**
- EV-ST-03 (VERIFIED): `hook_url` = `webhook_eb937a37` (workflow id), group `suricata,`. integratord alive but skipping all alerts (040). So Wazuh is "request-capable" in config but delivering 0.

**Webhook layer**
- EV-ST-04 (PARTIAL): Request-capable = YES (HTTP to `shuffle-backend:5001` resolvable, 041/042), but the path `webhook_eb937a37` does not match a live trigger id (`webhook_24636c49`) ⇒ POST would not bind to a running trigger. Destination at Shuffle = not currently triggered.

**IRIS destination layer**
- EV-ST-05 (VERIFIED→REGRESSED): Earlier executions returned HTTP 200 to `https://iriswebapp_nginx:8443/alerts/add` (IRIS object created, e.g. alert_id 58). The 3 most recent executions (7487d78d, 75e4be41, cc397d34) returned **HTTP 401 Authentication required**. So destination-capable = historically YES, currently FAILING.

## Adjudication matrix
| State | Class-A |
|-------|---------|
| Configured | YES (workflow + integratord block present) |
| Registered (live trigger) | NO (absent from `GET /api/v1/triggers`) |
| Running (live webhook) | NO (only suricata-eve-in running) |
| Request-capable | PARTIAL (resolvable but webhook-id mismatch) |
| Destination-capable (IRIS) | REGRESSED (401 now; 200 earlier) |

## Backup-Rollback
Read-only. No change.

## Stop conditions
Repair (047/050), trigger start (049), reload (057) are owner/approval-gated.

## Limitations
- "Running" of the embedded trigger object is self-reported config state, not live-registry proof.
- IRIS 401 root cause not repaired here (gated); see 045/047.

## Verdict rationale
Five-state adjudication completed with evidence; Class-A is Configured-only, not Registered/Running
live, Request-capable-partial, Destination-regressed. DONE.
