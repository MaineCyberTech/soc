# Phase 38-80: Endpoint Status Report

**Report ID:** phase38-80-endpoint-status
**Phase:** 38
**Title:** Phase 38-80: Endpoint Status Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-80-endpoint-status.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-80 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PARTIAL |

**Status:** PARTIAL
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-80-endpoint-status.md`
**Retention Class:** LONG

---

## 1. Executive Summary

Fleet is **8 of 9 registered endpoints ACTIVE at design intent**, but the live snapshot shows a wrinkle: agent **015 (Julians-Air)** — which reconnected earlier today (lastKeepAlive 20:11:20Z) — was **disconnected again at query time (21:06 UTC window)**. Agent **013 (SAMSUNG)** remains offline since 06:20Z today. Agent **008** is retired and absent from the roster. All agents run uniform **Wazuh v4.14.7**.

Tooling note: `agent_control` does not exist as an executable anywhere on this host (`find / -name "agent_control*"` → no results). Fleet status was pulled from the authoritative source instead: Wazuh API `GET /agents` on `127.0.0.1:55000`. A wrapper named `agent_control` should be created as backlog hygiene.

## 2. Command Output

```
$ TOKEN=$(curl -sk -u wazuh-wui:*** -X POST "https://127.0.0.1:55000/security/user/authenticate?raw=true")
$ curl -sk -H "Authorization: Bearer $TOKEN" \
    "https://127.0.0.1:55000/agents?agents_list=000,006,007,011,012,013,014,015,016&limit=20"

000 wazuh.master        active   v4.14.7  Amazon Linux           KA: 9999-12-31T23:59:59+00:00
006 docker-host         active   v4.14.7  Debian GNU/Linux       KA: 2026-08-25T21:06:23Z
007 mct-portal-dev      active   v4.14.7  Ubuntu 24.04.4 LTS     KA: 2026-08-25T21:06:23Z
011 mct-linux-client01  active   v4.14.7  Debian GNU/Linux       KA: 2026-08-25T21:06:23Z
012 MCT-WIN11PILOT      active   v4.14.7  Windows 11 Pro         KA: 2026-08-25T21:06:13Z
013 SAMSUNG             disconnected v4.14.7 Windows 11 Pro       KA: 2026-08-25T06:20:29Z
014 DESKTOP-MI54LFT     active   v4.14.7  Windows 11 Pro         KA: 2026-08-25T21:06:13Z
015 Julians-Air         disconnected v4.14.7 macOS               KA: 2026-08-25T20:11:20Z
016 mct-packet-sensor   active   v4.14.7  Debian GNU/Linux       KA: 2026-08-25T21:06:13Z
TOTAL: 9
```

(`agents_list=all` returned an API error; explicit ID list works — noted as minor API quirk.)

## 3. Per-Agent Detail

| ID | Name | Status | Version | OS | Last Keepalive | Groups / Notes |
|----|------|--------|---------|-----|----------------|----------------|
| 000 | wazuh.master | active (manager) | 4.14.7 | Amazon Linux | n/a (server) | manager node |
| 006 | docker-host | ACTIVE | 4.14.7 | Debian 13 (trixie) | 21:06:23Z | default, linux-servers; hosts sensor stack |
| 007 | mct-portal-dev | ACTIVE | 4.14.7 | Ubuntu 24.04.4 | 21:06:23Z | portal dev box, external IP 138.197.105.82 |
| 011 | mct-linux-client01 | ACTIVE | 4.14.7 | Debian GNU/Linux | 21:06:23Z | client Linux endpoint |
| 012 | MCT-WIN11PILOT | ACTIVE | 4.14.7 | Windows 11 Pro | 21:06:13Z | Windows pilot |
| 013 | SAMSUNG | **DISCONNECTED** | 4.14.7 | Windows 11 Pro | 06:20:29Z (~15h silent) | device offline — owner action required |
| 014 | DESKTOP-MI54LFT | ACTIVE | 4.14.7 | Windows 11 Pro | 21:06:13Z | healthy, no throttle observed |
| 015 | Julians-Air | **DISCONNECTED at query time** | 4.14.7 | macOS | **20:11:20Z today** | reconnected today per prior record; now flapping/offline again |
| 016 | mct-packet-sensor | ACTIVE | 4.14.7 | Debian GNU/Linux | 21:06:13Z | Suricata EVE forwarding functional |

### 014 healthy/no-throttle confirmation
Keepalive current within the 10s poll cadence; no queue/throttle events surfaced in this phase's checks; status `active`, `status_code 0`, config synced. Confirmed HEALTHY.

### 015 reconnect record (correction)
Prior phase records correctly show 015 reconnected today — corroborated by `lastKeepAlive = 2026-08-25T20:11:20Z`. However the live query (21:06–21:17 UTC) reports it `disconnected`, i.e., it dropped again ~1h after reconnect. Treat 015 as **INTERMITTENT/flapping macOS client**, not stably restored. Prior disconnect records stand as written; this report adds the post-reconnect relapse.

### 013 blocker
Offline ~15h. Blocker is physical/device availability — owner must power on/reconnect SAMSUNG. No server-side remediation applies.

### 008 retired
Confirmed: 008 does not appear in `GET /agents?agents_list=all` (total_affected_items = 9 including only IDs 000–016 minus 008). Retirement state consistent across fleet records.

## 4. Billing Eligibility

| Agent | Billable this cycle? | Basis |
|-------|----------------------|-------|
| 006, 007, 011, 012, 014, 016 | YES — full | Active with current keepalives |
| 015 | PARTIAL / judgment | Reconnected today then dropped; coverage gap hours not defensible for full billing without operator sign-off |
| 013 | NO (while offline) | Disconnected >15h; SLA clock should exclude outage window |
| 008 | NO | Retired |

## 5. Next Actions

1. **P2** — Watch 015 for another keepalive within 24h; if still absent, contact owner (macOS sleep/lid-close likely; consider launchd keep-alive review).
2. **P1** — Owner outreach for 013 power-on; if >72h offline, mark extended-absence per disposition runbook.
3. **P3** — Create `ops/scripts/agent_control` wrapper around the Wazuh API so future phases can literally "run agent_control -l".
4. **P3** — Fix or document the `agents_list=all` API failure (works with explicit list).

---
*Evidence: Wazuh API output captured 2026-08-25 21:06 UTC. No credentials printed.*
