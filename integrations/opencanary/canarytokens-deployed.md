# Canarytokens Deployed

Date: 2026-08-11
Status: **NOT DEPLOYED - requires canarytokens service + operator approval for placement**

## Starter token inventory (planned)

| # | Token | Type | Placement | Status |
|---|---|---|---|---|
| T1 | fake-backup-credentials.txt | document/file | client-shared backup folder (test) | PENDING deployment |
| T2 | fake-client-passwords.xlsx | document | admin desktop test share | PENDING |
| T3 | fake-do-api-key.txt | document | dev environment | PENDING |
| T4 | fake-vpn-config.zip | document | VPN config folder | PENDING |
| T5 | fake-admin-url-bookmark | URL | wiki/docs pages | PENDING |

## Deployment prerequisites

1. Canarytokens service: use canarytokens.org (hosted) or self-hosted
   canarytokens-docker on VM103 (needs build - same PVE/VM103 access question).
2. Webhook: point tokens at Shuffle webhook (notify-only) - webhook trigger
   creation per Phase 5.16 webhook hardening.
3. Placement approval: operator + client authorization (canary-authorization.md).

## No real secrets

All fake artifacts use placeholder strings only:
- fake-do-api-key.txt contains `AKIA_TESTPLACEHOLDER` style values
- fake-client-passwords.xlsx contains rows of `<REDACTED_FAKE>` values
- Never real credentials

## Lifecycle

- Rotate tokens annually or after trigger.
- Destroy artifacts at offboarding.
- Inventory maintained in canarytokens-inventory.md + this file.

## Blocker

- No canarytokens service provisioned (hosted token creation requires an
  account/approval; self-hosted requires VM103 build).
- No token test performed (nothing deployed).
