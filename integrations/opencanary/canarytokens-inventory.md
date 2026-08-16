# Canarytokens Inventory

Status: planned - no tokens deployed yet (deployment requires operator approval).

## Starter set

| # | Token | Type | Placement | Trigger | Created | Expires |
|---|---|---|---|---|---|---|
| T1 | fake-backup-credentials.txt | document/file token | client-shared backup folder (test) | file opened | pending | rotate yearly |
| T2 | fake-client-passwords.xlsx | document token | admin desktop test share | file opened | pending | rotate yearly |
| T3 | fake-do-api-key.txt | document token | dev environment | file read | pending | rotate yearly |
| T4 | fake-vpn-config.zip | document token | VPN config folder | zip opened | pending | rotate yearly |
| T5 | fake-admin-url-bookmark | URL token | wiki/docs pages | URL visited by non-admin | pending | rotate yearly |

## Placement rules

- Never place tokens where admins legitimately operate.
- Record placement (host, path, date, owner) in this inventory BEFORE deploying.
- Prefer canarytokens.org for client sites; self-hosted for MCT internal.

## Integration

```text
Canarytokens webhook -> Shuffle (notify-only) -> IRIS alert
  (template opencanary-hit, tag source:canarytokens, Class A)
```

## Lifecycle

1. Create token; configure webhook/email.
2. Place artifact; log in inventory.
3. On alert: IRIS case; verify not maintenance-triggered.
4. Rotate annually or after trigger; destroy old artifacts.

## False positive controls

- Inventory keeps placements searchable for maintenance review.
- Admin training: do not open unknown files/URLs in canary paths.

## No real credentials

All fake artifacts contain placeholder strings only
(e.g. `AKIA_TEST...`, `password: <REDACTED_FAKE>`). Never real secrets.
