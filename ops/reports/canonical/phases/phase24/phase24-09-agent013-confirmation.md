# Phase 24 Agent 013 Client Confirmation

Date: 2026-08-22
Status: **RESOLVED BY RECONNECT EVIDENCE** - 013 powered back on (client action), agent active.

## 1. Evidence

- 013 SAMSUNG reconnected **05:42 UTC 08-22** (EventChannel events flowing); active keepalive
  (05:47+). Offline 6d (08-16 13:27 -> 08-22 05:42) - consistent with powered-off, now
  confirmed by return.
- Telemetry healthy: EventChannel (313/6h), syscheck (169), SCA (6), VT (4); EID1 605/h,
  EID10 195/h.

## 2. NEW: 013 Sysmon EID7 flood

- 58,841 EID7 docs/1h (96% of archives) - same windows-clients issue as 014. Tuning (C1)
  extended to 013; before/after baselines captured (phase24-05/07).

## 3. Coverage/billing impact

- 013 now **covered + billable-active** (agent healthy, telemetry flowing; EID7 noise pending
  tuning). Coverage gap (6d) closed.

## 4. Decision

- **CONFIRMED: powered-on by client.** Fleet = 3/3 active. Remaining: 013 EID7 tuning (blocked
  on endpoint access) for signal quality.

## No secrets