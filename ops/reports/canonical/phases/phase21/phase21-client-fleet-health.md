# Phase 21 Client Fleet Health

Date: 2026-08-19

## Endpoint status

| id | Name | Platform | Status | Notes |
|---|---|---|---|---|
| 013 | SAMSUNG | Windows | offline (since 08-16) | likely powered off; no telemetry |
| 014 | DESKTOP-MI54LFT | Windows | **active** | Sysmon EventID 7 flood ongoing (~573K/24h); tuning prepared, apply blocked on endpoint access |
| 015 | Julians-Air | macOS | offline (since 08-18 09:04) | flood fix blocked on Mac access |

## Powered-off vs telemetry failure

- 013: powered-off consistent (no events; prior power pattern).
- 015: telemetry failure (flood -> disconnect), fix pending.
- 014: active; telemetry DEGRADED by EventID 7 noise (not offline).

## Billable endpoints

- 3 (013/014/015). Coverage: 014 monitored (noisy), 013 + 015 uncovered -> **billing NOT ready**
  (see `service-packaging/phase21-billing-readiness.md`).

## Unmanaged risk

- 2/3 billable endpoints uncovered (013, 015). 014 signal buried by flood. Elevated risk until
  operator actions complete.

## No secrets