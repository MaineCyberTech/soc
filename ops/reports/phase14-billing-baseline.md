# Phase 14 Billing Baseline

Date: 2026-08-16

## Billable endpoints (client 013)

| Endpoint | Category | Billable |
|---|---|---|
| SAMSUNG (agent 013, Windows 11 Pro) | EXTERNAL CLIENT | YES (1) |

## Internal/lab endpoints (NOT billable)

| Endpoint | Category |
|---|---|
| wazuh.master (000) | internal |
| docker-host (006) | internal |
| mct-portal-dev (007) | internal |
| securityonion (008) | internal |
| mct-linux-client01 (011) | internal pilot |
| MCT-WIN11PILOT (012) | internal pilot |

## Counts

- Billable: 1 (client endpoint)
- Internal: 6 (excluded from client billing)
- Velociraptor: 5 internal clients (not client-scoped)

## Billing policy

- Per service-packaging/billing-endpoint-count-policy.md.
- Billing starts at onboarding (2026-08-16); prorate or full-month per policy.

## No secrets
