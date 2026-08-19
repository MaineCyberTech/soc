# Phase 20 Client Fleet Health

Date: 2026-08-19

## Endpoint status

| id | Name | Platform | IP | Status | Notes |
|---|---|---|---|---|---|
| 013 | SAMSUNG | Windows | 192.168.111.166 | **offline** since 08-16 | likely powered off (no telemetry, no new keepalive; last 08-16 13:27) |
| 014 | DESKTOP-MI54LFT | Windows | 192.168.111.162 | **active** | **Sysmon EventID 7 flood** (08-18 21:00 -> 08-19 05:00, ~514K docs/24h) - tuning needed |
| 015 | Julians-Air | macOS | 192.168.111.77 | **disconnected** since 08-18 09:04 | flood fix pending Mac access |

Plus infra/pilot: 008 securityonion, 011 mct-linux-client01, 012 MCT-WIN11PILOT active.

## Powered-off vs telemetry failure

- **013 SAMSUNG**: consistent with powered-off (no events at all since 08-16; previous pattern
  in P18/P19 was power). Cannot distinguish definitively without a power/network check by the client.
- **015 Julians-Air**: telemetry failure caused by unified-log flood -> agent disconnect.
  Not a power issue (was actively flooding until 09:04 disconnect). Requires config fix on the Mac.

## Billable endpoints

- **3** (013/014/015). All three currently have issues -> **billing readiness = NOT READY** until
  fleet restored (see `service-packaging/phase20-billing-readiness.md`).

## Unmanaged risk (offline endpoints)

- 013 + 015 offline = no FIM/SCA/log coverage on 2/3 billable endpoints -> elevated unmanaged risk.
  Recommend client-side power/connectivity check for 013 and Mac-access fix for 015 before
  extending coverage guarantees.

## NEW: 014 Sysmon noise finding

- 014 active but emitting Sysmon **EventID 7 (Image Loaded)** at ~75K/hr (08-18 21:00-05:00),
  ~514K archive docs/24h, no rule match. Existing doc
  (`integrations/sysmon/sysmon-deployment-windows.md`) flags EventID 7 as "high volume - enable
  after tuning". Tuning (exclude EventID 7 in Sysmon config on 014) is an operator/Velociraptor
  item (endpoint not reachable from stack host).

## No secrets