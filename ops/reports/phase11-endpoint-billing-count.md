# Phase 11 Endpoint Billing Count

Date: 2026-08-16 (dry-run - no client)

## Counts (endpoint-count-report.sh)

- Total agents: 7 (6 active, 1 never-connected 009)
- Billable (client group): 0 (no client)
- Internal/lab: 6 (docker-host, portal, securityonion, linux-client, win11-pilot, master)
- Lab VMs: 201-205 (2 with agents: 204, 201)

## Billing categories (dry-run)

| Category | Count | Notes |
|---|---|---|
| Managed endpoints (client) | 0 | none yet |
| SIEM/alerting | 1 org | - |
| Vulnerability targets | 1 (lab) | client targets TBD |
| Canary | 1 VM | client tokens TBD |

## Sourcing

- Wazuh API (agents endpoint), agent_control, endpoint-count-report.sh.
- Velociraptor clients: 5 (dry-run count).

## No secrets

No secret values printed.
