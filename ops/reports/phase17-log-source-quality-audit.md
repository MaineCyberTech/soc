# Phase 17 Log Source Inventory and Quality Audit

Date: 2026-08-16

## Status: AUDIT COMPLETE - 1 live issue + tuning backlog

## Source volume (24h, by decoder)

| Decoder | Count | Quality |
|---|---|---|
| json (SO zeek) | 4,747 | GOOD (packet ingest) |
| sca | 2,215 | informational (compliance) |
| auditd | 1,301 | mixed (see 80710) |
| sshd | 740 | expected |
| docker | 731 | mixed (see 86003) |
| windows_eventchannel | 692 | GOOD |
| pam/sudo | 293 | expected |
| macOS_loginwindow | 7 | low (quiet Mac) |

## Top rules

| Rule | Count | Assessment |
|---|---|---|
| **120537** | **4,247** | **LIVE ISSUE: mct-portal Redis connection error loop (agent 007)** |
| 19007 | 1,528 | SCA summary (informational) |
| 80710 | 1,288 | auditd promiscuous mode - noisy? review |
| 86003 | 667 | docker errors (agent 006) - review |
| 5710 | 636 | sshd - expected |
| 92154/92153 | 324 | sysmon (post-suppression low) |

## Findings

1. **LIVE ISSUE - agent 007 Redis loop**: rule 120537 (level 5) "Task queue
   (Redis) connection error" - 4,247/24h, ongoing (138/hr at 08:00). Portal app
   cannot reach Redis. Action: check portal VM redis connectivity (outside stack
   - VM 007 is mct-portal-dev).
2. auditd promiscuous (80710, 1,288): likely sniffer/tcpdump activity on portal
   - verify legitimacy; tune if noise.
3. docker errors (86003, 667): agent 006 docker-host - review container errors.

## Recommendations (keep/tune/suppress)

- KEEP: json/zeek, windows_eventchannel, sshd, canary rules.
- SUPPRESS/TUNE: 120537 after Redis fixed (level 5 app error - could lower to 3
  once root cause resolved); 80710 if confirmed benign.
- MONITOR: 86003 docker errors.

## Backlog

- ops/reports/phase17-log-source-tuning-backlog.md

## No secrets

No secret values printed.
