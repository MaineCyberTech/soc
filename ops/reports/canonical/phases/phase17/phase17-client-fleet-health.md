# Phase 17 Client Fleet Health (013/014/015)

Date: 2026-08-16

## Status: 014/015 HEALTHY - 013 POWERED OFF - queue-full tuning needed

## Fleet

| Agent | Host | OS | Group | IP | Status | Node |
|---|---|---|---|---|---|---|
| 013 | SAMSUNG | Windows 11 | windows-clients | .166 | disconnected (powered off 06:41) | worker01 |
| 014 | DESKTOP-MI54LFT | Windows 11 | windows-clients | .162 | ACTIVE | worker01 |
| 015 | Julians-Air | macOS | mac-clients | .77 | ACTIVE | manager |

## Volumes (day 1 - onboarded today)

| Agent | Events 24h | level>=9 7d | Threats |
|---|---|---|---|
| 013 | 1,301 | 128 (historical FPs pre-suppression) | NONE |
| 014 | 537 | 6 (3x VaultCli FP, 2x queue, 1x AppCompat) | NONE |
| 015 | 92 | 12 (**ALL queue-full/flooded**) | NONE |

## Findings

1. **013**: powered-off workstation (normal) - monitoring resumes on power-on.
2. **014**: healthy; 3 VaultCli alerts = explorer.exe variant (validated FP class,
   non-suppressed by design).
3. **015**: **macOS agent is experiencing queue-full/flooded conditions** (12
   events in first hours) - unified logging volume exceeds agent queue.
   No threats, but telemetry may be dropped - see P17.04/05.

## No secrets

No secret values printed.
