# Phase 22 System Risk Register

Date: 2026-08-22

| # | Risk | Owner | Likelihood | Impact | Mitigation | Phase 23 action |
|---|---|---|---|---|---|---|
| R1 | 014 Sysmon EID7 flood active agent-side (throttled) | Operator (endpoint access) | High | Med-High | rule-11 throttle bounds impact | Apply tuning; validate >=90% drop |
| R2 | 015 offline (macOS flood, no Mac access) | Operator | High | High | repair bundle ready | Apply bundle; validate |
| R3 | 013 offline 6d (power) | Client | Med | Med | - | Power confirm |
| R4 | **Root disk 86%** (up from 76%) | SOC | High | High | 14d retention now enforced | Free space review; extend disk |
| R5 | **Swap 64%** (up from 49%) | SOC | Med | Med | - | Heap/memory review |
| R6 | pve222 API token missing (401) | SOC | Med | Med | manual checks | Obtain/refresh token |
| R7 | NetFlow scope unconfirmed (~423K/24h) | Operator | Med | Med | alerting unarmed | Confirm scope |
| R8 | Git history contains credential literals (79 commits) | SOC | Low | Med (if repo public) | repo is private; rotation recommended | Rotate values; optionally history scrub |
| R9 | wazuh-docker backups 600 now, but literals on disk | SOC | Low | Low | chmod 600 applied | env-abstraction completes |
| R10 | v1.1.0 release stale-by-1 commit (P21.8 pending re-release or accept) | SOC | Low | Low | docs say v1.1.0 published | include P22 in next release |
| R11 | Greenbone client scan unauthorized | Client | Med | Med | - | Signed auth |
| R12 | Redis loop ~10K/day (120537) | Portal VPS admin | High | Low | level 3 | VPS fix |
| R13 | Duplicate backup crons | SOC | Low | Low | - | de-duplicate |
| R14 | Cache manifest placeholders (misp/greenbone) | SOC | Low | Low | - | fill from VM103 |

## Accepted (documented)
- Git history literals (private repo; rotation preferred over history rewrite).
- Greenbone not externally verifiable (loopback-only design).
- Archives 14d retention tradeoff (alerts 30d preserved).

## No secrets