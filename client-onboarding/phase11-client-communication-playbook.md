# Phase 11 Client Communication Playbook

Date: 2026-08-16

## Template inventory

| Template | When | Sender | Notes |
|---|---|---|---|
| pilot-kickoff-email.md | client signed, day 0 | Account mgr | Sets expectations, contacts |
| agent-deployment-notice.md | before deployment | SOC | Endpoint list + what to expect |
| scan-authorization-request.md | before first scan | SOC | Authorization-gated |
| baseline-summary-email.md | baseline complete (~week 1) | SOC | Metrics snapshot |
| monthly-scorecard-delivery.md | monthly | Account mgr | Scorecard + attention items |
| incident-notification-draft.md | incident (L3/L4) | SOC on-call | Initial notification |
| pilot-completion-review.md | pilot end | Account mgr | Outcomes + recommendation |

## Rules

1. **Client-safe only**: no internal IPs, paths, tool names, rule IDs, or implementation details.
2. **Placeholders**: [Name], [Contact], [date], [N] - fill before send.
3. **Authorization-gated**: scan/deception actions reference signed authorization.
4. **Escalation**: incidents follow the escalation matrix (L4 immediate).
5. **Sign-off**: account manager approves before send.

## Sending workflow

1. Fill template placeholders from intake/scope data.
2. QA checklist (phase11-client-communications-qa.md).
3. Account manager review + send.
4. Log in client record.

## No secrets

No secret values printed.
