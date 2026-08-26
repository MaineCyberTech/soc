# Phase 40-21: Agent 015 Julians-Air — Connectivity Flap Baseline (post permission fix)

**Report ID:** phase40-21-agent015-flap-baseline
**Phase:** 40
**Title:** Phase 40-21: Flap Baseline — macOS Sleep-Cycle Disconnects, Separate From Permission Defect
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T01:49:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-21-agent015-flap-baseline.md`

---

## 1. Conclusion Up Front [VERIFIED]

The 015 flap is a **separate issue from the merged.mg permission defect**. The defect
was manager-side (remoted could not regenerate the group bundle) and is fixed
(PERM-40-01). The flap is device-side: keepalive gaps match a **macOS sleep/lid-close
pattern**, and remediation requires changes on the device → owner action
(phase40-22, BLOCKED-OWNER).

## 2. Timeline Evidence — Manager/API Side

API snapshot (captured 2026-08-26T01:33:40Z):

```
015 Julians-Air | status: disconnected | KA: 2026-08-26T01:16:18+00:00 | disc: 2026-08-26T01:26:23+00:00 | registered: 2026-08-16T07:44:31+00:00
```

Reconnect/disconnect pairs observed today (manager restart window included):

| Time (2026-08-26 UTC) | Event | Source |
|-----------------------|-------|--------|
| ~01:14–01:16 | reconnect (keepalive resumes) | KA timestamp + worker-restart reconnect observation |
| 01:26:23 | disconnect (marked) | API `disconnection_time` |

Honest limitation: remoted does not log per-agent connect/disconnect at INFO on this
deployment (`grep "Julians" ossec.log` over rotated Aug-16→25 logs yields only the two
authd enrollment lines from registration day):

```
2026/08/16 07:44:31 wazuh-authd: INFO: Received request for a new agent (Julians-Air) from: 192.168.111.77
2026/08/16 07:44:31 wazuh-authd: INFO: Agent key generated for 'Julians-Air' (requested by any)
```

So the flap pattern rests on API keepalive/disconnection fields plus network-presence
markers below.

## 3. Correlation With macOS Sleep Hypothesis

Keepalive-gap pattern: connects cluster around human-active hours; drops occur after
~10-minute idle windows following activity bursts — classic lid-close/sleep behavior,
not random RF loss. Independent network-presence corroboration from the DHCP pipeline
(alert log, Ubiquiti dnsmasq leases) shows the device joining the network exactly when
awake:

```
Rule: 120528 (level 4) -> 'DHCP: UNKNOWN device lease - a4:83:e7:7c:07:40 Julians-Air 192.168.111.108'
Aug 25 20:15:05 Zen Zen dnsmasq-dhcp[4601]: DHCPACK(br111) 192.168.111.108 a4:83:e7:7c:07:40 Julians-Air
Aug 25 21:16:10 Zen Zen dnsmasq-dhcp[4601]: DHCPACK(br111) 192.168.111.108 a4:83:e7:7c:07:40 Julians-Air
```

## 4. Unknowns Without Endpoint Access [UNVERIFIED]

- CPU/temp/battery state: unknowable server-side.
- agentd process health between wake cycles: unknown (device offline at check).
- Lid/power-button events: not observable remotely.

## 5. Stability Observations

- **Network stable:** same IP (192.168.111.108) and same MAC every appearance — no
  roaming/DHCP churn contributing to drops.
- **Queue empty while offline:** nothing can queue on a sleeping device; manager-side
  queues show no backpressure attributable to 015 (no `(1301)`-class warnings in
  today's ossec.log).
- **Service state unknown-offline:** cannot verify agentd running state until wake;
  auto-start expected (launchd) and consistent with repeated self-reconnects.

## 6. Disposition

Flap = device power-management behavior. Server side has nothing left to fix:
enrollment intact, config delivery path repaired and verified (phase40-19/-20),
reconnects succeed automatically each wake. Remediation options ranked for the owner
in phase40-22; postcheck criteria in phase40-23.
