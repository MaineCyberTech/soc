# Phase 27 Windows Telemetry Certification

Date: 2026-08-24
Status: **PARTIAL per endpoint** (volume certified; marker confirmation pending operator).

## Certificates

| Endpoint | Platform | Policy | EID1 | EID7 | EID10 | Buffer | Throttle | Verdict |
|---|---|---|---|---|---|---|---|---|
| 013 SAMSUNG | Sysmon 15.21/4.91 (Sysinternals) | 4.91+Signed (re-apply pending) | healthy (39/30m) | quiet (0/30m) | quiet | clean | - | **PARTIAL** (marker pending) |
| 014 DESKTOP-MI54LFT | Sysmon 15.21/4.91 | 4.91+Signed (accepted rc=0) | healthy (7/30m) | quiet (0/30m) | quiet | clean | active | **PARTIAL** (marker pending) |

## Owner action

- Operator: run re-apply/restart + `check-sysmon-tune.ps1` on both endpoints; post the
  `-s` dump -> SOC completes certification + throttle retirement + dashboard activation.

## Note

- Quiet EID7 is supporting evidence; marker is the direct proof (per pack: throttle absence
  is not health).

## No secrets