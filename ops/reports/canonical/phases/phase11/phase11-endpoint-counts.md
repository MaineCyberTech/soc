# Phase 11 Endpoint Counts

Date: 2026-08-16 (source: endpoint-count-report.sh)

## Wazuh agents

| ID | Name | Status | Category | Group |
|---|---|---|---|---|
| 000 | wazuh.master | active | internal | - |
| 006 | docker-host | active | internal | linux-servers |
| 007 | mct-portal-dev | active | internal | linux-servers |
| 008 | securityonion | active | internal (SO ingest) | default |
| 009 | ospd-openvas.local | never_connected | **disposition pending** | - |
| 011 | mct-linux-client01 | active | lab/pilot | linux-clients |
| 012 | MCT-WIN11PILOT | active | lab/pilot | windows-clients |

## Categorization

| Category | Count |
|---|---|
| Billable (client-<slug>) | 0 |
| Internal | 4 (000, 006, 007, 008) |
| Lab/pilot | 2 (011, 012) |
| Pending disposition | 1 (009) |

## Velociraptor clients

- 5 enrolled (2 linux lab, 1 windows pilot, +2)

## Billing (see service-packaging/billing-endpoint-count-policy.md)

- Client endpoints: 0 (no client) - populate at onboarding.
- Internal/lab endpoints: NOT billed.

## No secrets

No secret values printed.
