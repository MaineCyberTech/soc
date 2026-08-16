# MCT Security Monitoring - Client Onboarding Package

Version: 1.0 (2026-08-11)
Classification: CLIENT CONFIDENTIAL (share with client; does not expose MCT internal stack secrets)

## What this package covers

1. Client intake
2. Asset inventory
3. Agent deployment
4. Windows Sysmon option
5. Vulnerability scanning authorization
6. Canary placement authorization
7. Alert notification preferences
8. Monthly scorecard scope
9. Incident response escalation contacts
10. Data retention and access
11. Offboarding

## Documents in this package

| Document | Purpose |
|---|---|
| client-intake-form.md | Client/org/sites/networks/contacts |
| agent-onboarding-checklist.md | Endpoint coverage + agent install |
| vulnerability-scan-authorization.md | Authorization for scanning client assets |
| canary-authorization.md | Authorization + placement for deception |
| monthly-scorecard-template.md | Monthly report scope/preview |
| escalation-matrix.md | Who to contact and when |
| offboarding-checklist.md | Clean removal |

## MCT monitoring model (client summary)

- Endpoint monitoring (Wazuh agent) - always-on
- Network flow analysis - at gateways/client sites
- Deception (canaries) - optional, with authorization
- Vulnerability scanning (scheduled, non-invasive first) - with authorization
- 24/7 alert monitoring with defined escalation
- Monthly scorecard reporting

## MCT commitments

- No automated blocking or destructive actions without client approval.
- All changes recorded and reported.
- Data accessed only for monitoring and response.
- Regular reporting per agreed scope.
