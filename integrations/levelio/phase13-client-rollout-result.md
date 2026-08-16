# Phase 13/16 Client Rollout Result (Level.io)

Date: 2026-08-16 (updated)
Status: **3 CLIENT ENDPOINTS DEPLOYED + VERIFIED**

## Endpoints

| Agent | Hostname | OS | IP | Status | Group |
|---|---|---|---|---|---|
| 013 | SAMSUNG | Windows 11 | .166 | active (powered off at check) | windows-clients |
| 014 | DESKTOP-MI54LFT | Windows 11 | .162 | active | windows-clients |
| 015 | Julians-Air | macOS | .77 | ACTIVE | default* |

*015 enrolled to default group (Level.io action did not pass WAZUH_AGENT_GROUP);
mac-clients group can be created + agent reassigned if desired.

## Deployment fixes applied (macOS path)

1. Arch-specific pkg URL (intel64/arm64) - was 403 on generic name.
2. curl fail-fast + empty-file check (silent 403 masked before).
3. Self-contained helpers inlined (lib/mct-env.sh never reaches endpoint).
4. BASH_SOURCE unbound fix for stdin exec mode.

## Validation

- 015 ACTIVE, keepalive fresh, "New wazuh agent connected" event received.
- macOS unified logging collection active (quiet workstation = low volume).

## No secrets
