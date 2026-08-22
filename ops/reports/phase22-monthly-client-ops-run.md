# Phase 22 Monthly Client Ops Run

Date: 2026-08-22

## Run checklist

| Item | Status | Evidence |
|---|---|---|
| Health | 0 FAIL | full-stack-health-20260822-032917 |
| Backups | OK | snap <24h, S3 <48h, config <48h (cron duplication noted) |
| Endpoint coverage | 1/3 healthy | 014 active (degraded); 013/015 offline |
| Alert quality | IMPROVED | Zeek ~316/day (99.9% reduction); 014 flood throttled |
| Packet/flow posture | READY (approval-pending) | Zeek Class A routing plan; Suricata gated |
| Retention | FIXED this phase | archives-14d attached (was stale attach) |
| Scorecard | DRAFT | phase22-scorecard-progress |
| Billing readiness | NOT READY | 2/3 uncovered; 014 degraded |
| Authorization | Greenbone unsigned | - |
| Repo/release | v1.1.0 published | P22 work pending commit |

## Actions logged

1. Retention ISM attach fixed (archives-14d on 08.19-08.22).
2. Compose secret templating + .env (wazuh-docker) - verified, no recreation.
3. Runtime images digest-pinned (5); image policy enforced (0 violations).
4. CI pyc pollution fixed; opencanary XML -> md; relay.py fallback removed; backups chmod 600.
5. Mac bundle reviewed/fixed + packaged; Sysmon config recorded; Zeek clean-window validated.

## Retrospective

- Biggest operational win: signal noise collapsed (Zeek 99.9%; floods throttled/enforced retention).
- Biggest risk: disk 86% + swap 64%; fleet 2/3 uncovered; endpoint-access blockers persist.

## No secrets