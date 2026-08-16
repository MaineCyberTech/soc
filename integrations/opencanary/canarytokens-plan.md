# Canarytokens Usage Plan

## Token types

| Token | Placement | Alert trigger | Class |
|---|---|---|---|
| Fake secrets file (AWS/RDP/DB creds) | Client file shares, admin desktops | File opened/exfiltrated | A |
| Fake admin URL | Internal wiki/docs pages | Visited by non-admin | A |
| Fake DB credentials | Dev environments | Used | A |
| DNS token | Rarely visited subdomain | DNS lookup | A |
| Document token (PDF/Office) | Shared drives, email attachments | Opened | A |

## Placement rules

- Never place tokens where an admin would legitimately touch them (production file paths, CI pipelines).
- Record every placement in the canary token inventory (token type, host, path, date, owner) so maintenance doesn't trigger false alarms.
- Prefer canarytokens.org (hosted) for client sites; self-hosted canarytokens-docker on a separate VM for MCT internal (keeps alerts inside the stack).

## Integration

```text
Canarytokens webhook -> Shuffle webhook (notify-only)
  -> IRIS alert (template opencanary-hit, tag source:canarytokens)
  -> Class A notify
```

- Webhook target: Shuffle webhook URL for canarytokens (see integrations/shuffle workflows).
- Fallback: email to SOC inbox (notify-only) if Shuffle degraded.

## Lifecycle

1. Create token; configure webhook/email.
2. Place artifact; record in inventory.
3. On alert: IRIS case (Class A), verify token was not triggered by maintenance.
4. Rotate token after trigger or annually; destroy old artifacts.

## False positive controls

- Document all placements (inventory file).
- Maintenance windows: temporarily mark token as expected-triggered in ops/reports.
- Admin training: inform admins not to open unknown files/URLs in canary paths.

## Current status

- Plan documented; no tokens deployed yet (Phase 3 delivers the plan).
- Deploy first token set with a client site on request (client-like group).
