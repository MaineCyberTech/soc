# Managed Security SLA Template

Client: ______________  Effective: ______________

## Response times

| Priority | Definition | Response | Resolution target |
|---|---|---|---|
| P1 | Active compromise / data loss | 15 min notify, 24/7 | begin containment within 1h |
| P2 | Confirmed suspicious | same business day | 48h |
| P3 | Suspicious, unconfirmed | next business day | 1 week |
| P4 | Informational | monthly report | n/a |

## Availability

- Monitoring coverage: 24/7/365 (alert pipeline).
- Reporting: monthly, delivered by 5th business day.
- Planned maintenance: notified 48h ahead (no data loss).

## Responsibilities

| Party | Responsibility |
|---|---|
| MCT | monitoring, alerts, reporting, escalation, evidence preservation |
| Client | contacts, access for investigation, approval for containment/scan/canary |

## Exclusions

- Acts of god, client-caused outages, unapproved scope expansion.
- Automated blocking without approval (unless emergency isolation + immediate notice).

## Reporting

- Monthly scorecard = SLA evidence (coverage, incidents, response times).

## Review

- Quarterly SLA review; adjust scope/pricing per matrix.
