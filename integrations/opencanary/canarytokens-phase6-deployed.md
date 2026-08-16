# Canarytokens Phase 6 Deployment

Date: 2026-08-11
Status: **NOT DEPLOYED - no canarytokens service provisioned (blocker documented)**

## Inventory (planned - no real credentials)

| # | Token | Type | Placement | Status |
|---|---|---|---|---|
| T1 | fake-backup-credentials.txt | document | client-shared backup folder | PENDING service |
| T2 | fake-client-passwords.xlsx | document | admin desktop test share | PENDING |
| T3 | fake-do-api-key.txt | document | dev environment | PENDING |
| T4 | fake-vpn-config.zip | document | VPN config folder | PENDING |
| T5 | fake-admin-url-bookmark | URL | wiki/docs pages | PENDING |

## Blocker

- No canarytokens service: hosted (canarytokens.org) requires account/approval;
  self-hosted (canarytokens-docker) requires VM build (PVE blocked).
- Webhook path exists (wazuh-high-severity trigger) - ready once tokens exist.

## No real secrets

All fake artifacts placeholder-only (AKIA_TEST..., <REDACTED_FAKE> values).

## When service is available

1. Create token with webhook -> http://shuffle-frontend/api/v1/hooks/webhook_<id>.
2. Place T1 in controlled location; record inventory.
3. Trigger test; validate IRIS alert (opencanary-hit template, source:canarytokens).
4. Cleanup per lifecycle.
