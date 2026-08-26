# Phase 39 Fleet Scorecard — Live Per-Agent Table + Client-Safe Summary

**Report ID:** phase39-80-fleet-scorecard
**Phase:** 39
**Title:** FLEET-39-01 — 10 Agents Pulled Live From Wazuh API (7 Active, 2 Disconnected, 1 Retired-Class); Per-Agent Cert/Telemetry/Billing Columns; Trend Notes on 015 Flap and 013 Aging Offline
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:47:30Z
**Classification:** INTERNAL (§2 is client-safe)
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-80-fleet-scorecard.md`

---

## 1. Internal scorecard — live API pull 2026-08-25T23:47Z

| ID | Name | Status | Version | Platform | lastKeepAlive (UTC) | Cert state (P33–35) | Telemetry quality | Throttle | Billing eligible | Owner | Next action |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 000 | wazuh.master | active | v4.14.7 | amzn (manager) | n/a (self) | n/a | n/a | none | n/a | MCT SOC | — |
| 006 | docker-host | active | v4.14.7 | debian | 23:47:17 | not certified | good | none | yes (infra, internal) | MCT SOC | optional cert run |
| 007 | mct-portal-dev | active | v4.14.7 | ubuntu | 23:47:27 | not certified | good | none | yes (internal) | MCT SOC | optional cert run |
| 008 | securityonion | disconnected | v4.14.7 | ol | 2026-08-24T18:59:59 | retired-class | n/a | n/a | no | owner decision | RETIRED per records; confirm decommission |
| 011 | mct-linux-client01 | active | v4.14.7 | debian | 23:47:17 | not certified | good | none | yes (client) | owner | schedule cert |
| 012 | MCT-WIN11PILOT | active | v4.14.7 | windows | 23:47:17 | pilot (W1/W2 scope) | good | none | yes (client) | owner | keep pilot |
| 013 | SAMSUNG | disconnected | v4.14.7 | windows | 2026-08-25T06:20:29 | CERTIFIED P33–35 | degraded → offline since 06:30Z | n/a offline | no (while down) | owner | REC-013-39 physical recovery |
| 014 | DESKTOP-MI54LFT | active | v4.14.7 | windows | 23:47:17 | CERTIFIED P33–35 | good | none | yes (client) | owner | none |
| 015 | Julians-Air | disconnected | v4.14.7 | darwin/macOS 14.8.7 | 2026-08-25T23:14:35 | not certified | intermittent (flap) | sleep-cycle gaps | marginal | owner | FLAP-015-39 remediation choice |
| 016 | mct-packet-sensor | active | v4.14.7 | debian | 23:47:27 | ingest-baseline P35 | good (canary sid provenance) | none | yes (sensor) | MCT SOC | maintain |

Cert-state basis: P33/P34/P35 contain final + 24h certifications only for agents
013 and 014 (`phase35-*` titles verified); no certification records exist for
006/007/011/012/015/016 → marked "not certified" honestly.

## 2. Client-safe summary (counts only)

- **Endpoints monitored today: 7 active** of 9 managed endpoints (1 retired).
- Detection coverage remains continuous for Linux servers, the Windows pilot,
  and the network sensor; two endpoints are currently offline (one Windows
  laptop awaiting physical power-on, one macOS laptop with intermittent sleep
  behavior).
- Alerting pipeline and log retention operating normally; no data loss detected
  in covered tiers.

## 3. Trend notes

- **015 flapping:** hourly wake-check keepalives with daytime activity clusters
  (see FLAP-015-39 telemetry table). Pattern stable across Aug-24/25.
- **013 aging offline:** clean 06:30Z cutoff today after heavy overnight volume;
  every additional day offline widens its certification staleness window.
- **008:** disconnected 2026-08-24T19:00Z, consistent with retirement; recommend
  formal agent-delete once decommission confirmed.

## 4. Fresh-truth statement

All §1 rows were pulled live from `/agents` at write time; nothing carried
forward from earlier phase tables except the cert-state column, which cites its
P33–35 sources explicitly.
