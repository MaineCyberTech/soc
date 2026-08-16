# Client Zero Escalation

Client: Maine Cyber Tech (Internal)

## Priority definitions

| Priority | Definition | Response |
|---|---|---|
| P1 | Active compromise / data loss risk | Immediate, 24/7 |
| P2 | Confirmed suspicious activity | Same-day |
| P3 | Suspicious but unconfirmed | Next business day |
| P4 | Informational | Monthly |

## Escalation chain (internal)

| Priority | Contact | Channel | Availability |
|---|---|---|---|
| P1 | SOC on-call analyst | internal alerting + phone | 24/7 |
| P2 | SOC lead | internal queue | business + on-call |
| P3 | MCT management | email | business hours |
| P4 | reporting digest | monthly scorecard | n/a |

## Notification triggers

- OpenCanary hit -> P1 IRIS case + notify
- MISP IOC match -> P1 (Class A)
- Unknown flow exporter -> P1
- Lateral movement -> P1
- Critical vuln (internet-facing) -> P2 IRIS
- Agent offline > 24h (critical asset) -> P2
- UniFi flood/storm -> P2

## Contact expectations

- P1: notify within 15 min of confirmation.
- P2: same business day.
- P3: next business day.
- Client (MCT mgmt) updated via scorecard monthly + ad-hoc for P1.

## Safety

- Containment actions require approval (internal owner = MCT mgmt).
- No automated destructive actions.
