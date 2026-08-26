# Phase 22 Windows 014 Sysmon Before/After Validation

Date: 2026-08-22
Status: **BEFORE (THROTTLED) - AFTER PENDING** (apply blocked on endpoint access).

## Before (documented)

| Metric | 08-19 (pre-throttle) | 08-22 (throttled) |
|---|---|---|
| EventID 7 | 573,809 archive docs/24h | agent-side still flooding; rule-11 throttle suppresses analysis (98 EID7 alerts/24h; 4 throttle msgs; 13 buffer flood events) |
| EventID 1 | 15,186/24h | suppressed in archives (throttle) |
| EventID 10 | 1,499/24h | suppressed in archives |

Note: index-side archive counts are NOT a valid before/after metric while rule-11 throttling
is active. Validation must use agent-side counters (operator) + surviving alert counts + buffer
events as proxies until the flood stops and archives resume.

## After targets

- EventID 7: >=90% reduction (agent-side; < 60K/day).
- EventID 1: unchanged/flowing; EventID 10: unchanged/flowing.
- Agent buffer: 0 flooded/full events in 24h.
- Archives resume (rule-11 throttle clears) with EID7 volume visibly reduced.

## Re-validation procedure (post-apply)

1. Agent-side: `Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 1000 | Where EventID 7` counts over 15m/1h windows (operator).
2. SOC: surviving EID7 alerts + rule-11 messages + buffer events per hour.
3. 24h archive volume once throttling clears.

## Decision

- **BEFORE: FAIL** (flood active agent-side, throttle engaged).
- **AFTER: PENDING** (endpoint access + approval).

## No secrets