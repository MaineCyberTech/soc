# Canarytokens Operations Runbook

## Lifecycle

1. Create token (canarytokens.org or self-hosted).
2. Configure webhook: Shuffle notify-only webhook (webhook map) or SOC email fallback.
3. Record placement in canarytokens-inventory.md BEFORE deploying.
4. Place artifact at the recorded location.
5. Alert handling: Class A -> IRIS (opencanary-hit template, tag source:canarytokens).
6. Maintenance: verify not self-triggered; document in ops/reports.
7. Rotation: annually or after trigger.
8. Offboarding: destroy artifacts, revoke tokens.

## Alert response

1. Confirm token type + placement (inventory lookup).
2. Exclude maintenance/admin touches (inventory check).
3. Open IRIS case (Class A) with raw webhook payload.
4. Determine what touched the token (file open, URL visit, DNS lookup).
5. Containment: manual approval only.

## False positive controls

- Inventory is the source of truth for placements.
- Admin training: don't open unknown files/URLs in canary paths.
- Maintenance windows: mark expected-triggered tokens in ops/reports.

## Safety

- Fake artifacts never contain real credentials.
- Tokens alert-only; no blocking/remediation.
- Cleanup after validation tests.
