# Phase 40-14: Agent 013 SAMSUNG — Offline Baseline

**Report ID:** phase40-14-agent013-baseline
**Phase:** 40
**Title:** Phase 40-14: Agent 013 SAMSUNG — Offline Baseline (Endpoint Recovery Arc)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:42:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-14-agent013-baseline.md`

---

## 1. Purpose

Authoritative pre-recovery baseline for agent **013 (SAMSUNG)**, disconnected since
2026-08-25T06:30:48Z (>19h at capture). This record fixes last-seen truth, identity,
and unknowns so that recovery (phase40-15) and postcheck (phase40-16) have a stable
reference. All values below are live pulls from the Wazuh API on `127.0.0.1:55000`
and manager container logs. [VERIFIED]

## 2. Live Fleet Pull (real output)

Command: `curl -sk -H "Authorization: Bearer $TOKEN" "https://127.0.0.1:55000/agents?agents_list=015,013"` (token via wazuh-wui auth, value never printed)

```
013 SAMSUNG | status: disconnected | KA: 2026-08-25T06:20:29+00:00 | disc: 2026-08-25T06:30:48+00:00 | registered: 2026-08-16T04:26:58+00:00
```

Full record (GET /agents filtered to 013), captured 2026-08-26T01:33:40Z:

```json
{
 "os": {"arch": "x86_64", "build": "26200.9106", "major": "10", "minor": "0",
        "name": "Microsoft Windows 11 Pro", "platform": "windows",
        "uname": "Microsoft Windows 11 Pro", "version": "10.0.26200.9106"},
 "ip": "192.168.111.166",
 "id": "013",
 "node_name": "manager",
 "group_config_status": "synced",
 "dateAdd": "2026-08-16T04:26:58+00:00",
 "version": "Wazuh v4.14.7",
 "lastKeepAlive": "2026-08-25T06:20:29+00:00",
 "disconnection_time": "2026-08-25T06:30:48+00:00",
 "mergedSum": "0744ee0e055e3489444173ed65ff2c19",
 "registerIP": "any",
 "status": "disconnected",
 "configSum": "e8d301f4e52cf976aeebc6bbf86032c8",
 "name": "SAMSUNG",
 "status_code": 4,
 "group": ["windows-clients"],
 "manager": "wazuh.master"
}
```

Fleet context at same pull — active: 000, 006, 007, 011, 012, 014, 016;
disconnected: 013, 015; retired-disconnected: 008 (securityonion, disc 2026-08-24T19:00:17Z).

## 3. Last-Seen Timeline [VERIFIED]

| Event | Value |
|-------|-------|
| Last keepalive received | 2026-08-25T06:20:29Z |
| Marked disconnected | 2026-08-25T06:30:48Z (monitord DISCONNECTION_TIME default) |
| Silent duration at capture (01:42Z Aug-26) | ≈ 19h21m since last keepalive |
| Registered | 2026-08-16T04:26:58Z |

Manager-log corroboration attempt (honest negative): current `ossec.log` (rotated
00:00:10 today) and rotated `wazuh/2026/Aug/ossec-25.log.gz` contain **zero**
lines matching `SAMSUNG|"013"` — remoted emits per-agent connect/disconnect only at
DEBUG verbosity, which is not enabled on this deployment. The API fields above are
therefore the authoritative last-seen source.

```
$ docker exec multi-node-wazuh.master-1 zcat /var/ossec/logs/wazuh/2026/Aug/ossec-25.log.gz | grep -ciE "samsung"
0
```

## 4. Version / Platform History

| Field | Value |
|-------|-------|
| Agent version | Wazuh v4.14.7 (fleet-uniform) |
| OS | Microsoft Windows 11 Pro, 10.0.26200.9106, x86_64 |
| Group | windows-clients |
| Config state at loss | `group_config_status: synced`; mergedSum/configSum present → config was fully delivered before going dark |

No version changes observed since registration (single enrollment 2026-08-16, no
re-enrollment events — authd log for Aug-25 shows no 013 activity).

## 5. Access Path Assessment — NO OPERATOR PATH EXISTS [VERIFIED]

| Path | Status |
|------|--------|
| RMM tooling from this environment | None provisioned (no RMM container/service in stack inventory) |
| Operator/RMM credential store | No endpoint-side credentials held server-side |
| Physical access | This environment is headless server-side only; no path to device location |
| SSH/WMI/winrm reachability | Not attempted — out of scope without owner approval; device presumed powered off (no ARP presence evidence available server-side) |

Conclusion: every recovery lever requires **owner action** (physical power-on or
owner-provisioned MDM/RMM channel). Recovery is BLOCKED-OWNER-ACTION — see phase40-15.

## 6. Unknowns While Offline (explicit list) [UNVERIFIED by nature]

1. Power state (asleep vs powered off vs battery-dead) — indistinguishable remotely here.
2. Network presence (same subnet? DHCP lease renewed? IP .166 still bound?).
3. Service state (`WazuhSvc` running/stopped/disabled).
4. OS patch state since 06:20Z Aug-25 (Windows Update may have rebooted it into a stuck state).
5. Queue/backpressure state — N/A while offline; any local buffer behavior unknowable until reconnect.

## 7. Certification & Billing Impact

- Certification: **lapsed** — connectivity SLA broken >19h; see phase40-17.
- Billing: **non-billable while offline**; outage window 2026-08-25T06:30:48Z → restoration
  must be excluded from billable coverage hours.

## 8. Owner Ask (verbatim draft)

> Subject: Action needed — security monitoring agent offline on SAMSUNG (Windows PC)
>
> Your Windows machine ("SAMSUNG") has been unreachable by our security monitoring
> since 06:30 UTC on 25 August 2026 (over 19 hours). We have no remote-management
> path to it and cannot restore monitoring from our side.
>
> Please do ONE of the following at your earliest convenience:
> 1. Power the machine on and ensure it is connected to the internet
>    (wake it, open the lid, or plug into network). The monitoring service
>    will reconnect automatically within minutes — no other action needed; OR
> 2. If the machine is being decommissioned or is away long-term, tell us so we
>    can mark it accordingly.
>
> Until then this device is NOT receiving security telemetry, alerting, or
> monitoring coverage.

## 9. Next Actions

1. Owner executes ask above (P1).
2. On power-on: execute runbook phase40-15 §4, then postcheck phase40-16 same day.
3. If >72h silent: extended-absence disposition per endpoint status runbook.
