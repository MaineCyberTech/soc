# Phase 36: Endpoint Recovery Strategy

Date: 2026-08-25

## Disconnected agents

| Agent | Likely cause | Recovery |
|---|---|---|
| 008 (securityonion) | RETIRED | N/A — decommissioned |
| 013 (SAMSUNG) | Device offline | Wait for wake |
| 015 (Julians-Air) | macOS sleep | Wait for wake |

## Strategy
1. Monitor keepalives
2. Agents auto-reconnect on device wake
3. No remote intervention needed
4. If 013/015 don't reconnect in 24h: operator to check

## No action taken
## No secrets
