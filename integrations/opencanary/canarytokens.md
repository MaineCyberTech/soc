# Canarytokens Workflow

Purpose: deploy Canarytokens (canarytokens.org or self-hosted) for file, secret, and URL decoys that fire alerts into the MCT flow.

## Token types planned

| Token | Placement | Alert trigger | Notes |
|---|---|---|---|
| Fake secrets file (AWS/RDP) | Client-shared file shares, admin desktops | File opened/exfiltrated | Attach to admin portals |
| Fake admin URL | Internal wiki/docs pages | URL visited by a non-admin | Adversary tracking |
| Fake database credentials file | Dev environments | Credentials used | Credential access indicator |
| DNS token | Rarely visited subdomain | DNS lookup | Network-level canary |

## Workflow

1. Create token in Canarytokens (https://canarytokens.org/generate or self-hosted `canarytokens-docker`).
2. Configure the token's webhook to `http://<shuffle-host>:3001/api/v1/webhooks/canarytokens` or email to the SOC inbox (notify-only default).
3. Place the token artifact per its documentation (do not place tokens that an admin would legitimately use).
4. Record placement in the secret/asset inventory so maintenance does not trigger it.

## Integration path

```text
Canarytokens webhook/email
  -> Shuffle webhook (notify-only)
  -> IRIS alert (template: opencanary-hit.md, source tag canarytokens)
  -> Class A notify
```

## Self-hosted option

- `canarytokens/canarytokens-docker` compose under `compose/` when dedicated hosting is needed (recommended for client sites so tokens phone home to MCT infrastructure).

## Rules

- Tokens must be documented in the internal asset inventory with owner + placement.
- Never place tokens in paths used by automated tools (backup scripts, scanners).
- If a token fires: treat as Class A, follow `incident-triage.md`, do not announce the token network.

## Backup

- Token configuration (domains, webhook URLs) — covered by `backup-phase2-config.sh` when self-hosted.

## Rollback

- Disable token in Canarytokens console; remove webhook from Shuffle if needed.
