# Phase 11 Billing Review

Date: 2026-08-16 (dry-run - no client)

## Categories + rates (template)

| Category | Unit | Rate | Count (now) | Monthly |
|---|---|---|---|---|
| Managed endpoint | per endpoint | TBD | 0 (client) | $0 |
| SIEM/alerting | per org | TBD | 1 | TBD |
| Vulnerability target | per target | TBD | 0 (client) | $0 |
| Canary/deception | per item | TBD | 0 (client) | $0 |
| DFIR retainer | optional | TBD | 0 | $0 |

## Endpoint source (2026-08-16)

- 7 Wazuh agents (6 active, 1 pending disposition).
- 5 Velociraptor clients.
- Billable: 0 (no client engaged).

## Process

1. Run endpoint-count-report.sh (1st of month).
2. Categorize (client vs internal/lab).
3. Populate this template -> monthly-billing-review-template.md.
4. Verify vs level.io device groups.

## No secrets

No secret values printed.
