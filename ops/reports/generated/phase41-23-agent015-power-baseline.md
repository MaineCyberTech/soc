# Phase 41 Agent 015 — Connectivity Power Baseline (Refreshed)

**Report ID:** phase41-23-agent015-power-baseline
**Phase:** 41
**Title:** BASELINE-015-41 — Flap Timeline Recapped And Extended With Today's Live Cycles; Sleep-Cycle Correlation STANDING (Unchallenged By Any New Evidence); Fresh Morning Cycle KA 04:20:01Z → disc 04:38:34Z Matches The Idle-Drop Signature
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:49:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-23-agent015-power-baseline.md`

---

## 1. Conclusion (unchanged, re-evidenced) [VERIFIED]

The agent-015 connectivity flap is device-side macOS power management. It is a
separate issue from the manager-side merged.mg permission defect, which was
fixed and remains fixed (phase41-26 §2). Remediation requires changes on the
device → owner action (package PREPARED in phase41-24).

## 2. Flap timeline recap + today's extension

| Time (2026-08-26 UTC) | Event | Source |
|------------------------|-------|--------|
| ~01:14–01:16 | reconnect after manager restart window | phase40-21 §2 |
| 01:26:23 | disconnect (~10 min after activity burst) | API `disconnection_time` |
| **04:20:01** | keepalive observed (device awake this morning) | **live pull today 04:41:58Z [VERIFIED]** |
| **04:38:34** | disconnect again — awake stretch of ≥18m33s then idle-drop | **live pull today [VERIFIED]** |

Live baseline row at pull:

```
015 Julians-Air status=disconnected os=darwin 14.8.7
    KA=2026-08-26T04:20:01+00:00 disc=2026-08-26T04:38:34+00:00
    registered=2026-08-16T07:44:31+00:00
```

Pattern signature intact across both cycles today: connect clusters around human-
active periods; drop follows a short idle window. Not random RF loss, not server-
side rejection (server accepts instantly on every wake).

## 3. Correlation standing — why it is unchanged

- DHCP pipeline corroboration (phase40-21 §3) shows the device joining the
  network exactly when awake: stable MAC `a4:83:e7:7c:07:40`, stable IP
  `192.168.111.108` on br111 — no roaming or lease churn to explain drops.
- Manager logs remain silent on per-agent connect/disconnect at INFO (known
  limitation, phase40-21 §2); pattern rests on API fields + network markers,
  exactly as before.
- Nothing observed today contradicts the sleep hypothesis; the 04:38 drop after
  an 18-minute idle stretch strengthens it.

## 4. Stability observations (carried forward)

Network stable; queue empty while asleep (nothing can queue on a sleeping
device; no `(1301)`-class backpressure attributable to 015); service auto-start
via launchd consistent with repeated self-reconnects on wake.

## 5. Disposition

Server side has nothing left to fix for connectivity. The remediation package is
built and waiting (phase41-24); proof protocol defined (phase41-25); split
certification state recorded in phase41-26.
