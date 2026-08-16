# Incident Response Escalation Matrix

Client-safe version. Contact paths for security events.

## Priority levels

| Priority | Definition | Response |
|---|---|---|
| P1 - Critical | Active compromise / data loss risk | Immediate notify, 24/7 |
| P2 - High | Confirmed suspicious activity | Same-day |
| P3 - Medium | Suspicious but unconfirmed | Next business day |
| P4 - Low | Informational / digest | Monthly report |

## MCT internal escalation

| Role | Contact | Available |
|---|---|---|
| SOC analyst | <via MCT portal/email> | 24/7 for P1 |
| SOC lead | <email> | business hours + on-call P1 |
| MCT management | <email> | as needed |

## Client escalation contacts (from intake form)

| Priority | Name | Phone | Email | After-hours |
|---|---|---|---|---|
| P1 | | | | |
| P2 | | | | |
| P3 | | | | |

## Event notification flow

1. Alert detected (24/7 monitoring).
2. Triage: confirm/classify (P1-P4).
3. P1/P2: notify client per above contacts.
4. Investigation continues (evidence preserved).
5. Monthly: all events summarized in scorecard.

## Client responsibilities

- Provide current escalation contacts (update form on change).
- Provide access for incident investigation when needed.
- Approve containment actions (MCT does not act destructively without approval).

## Notes

- MCT never performs blocking/quarantine/firewall changes without client approval (except temporary emergency isolation with immediate notification).
- This matrix is the client-visible portion of the internal escalation runbook.
