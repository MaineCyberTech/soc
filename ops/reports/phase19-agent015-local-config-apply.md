# Phase 19 Agent 015 Local Config Apply

Date: 2026-08-18
Status: **BLOCKED BY ENDPOINT ACCESS** - agent-local config apply requires hands on Julians-Air (192.168.111.77, macOS). This OpenCode session has no SSH/remote path to the Mac.

## 1. Agent-local access confirmation

- Wazuh API: agent 015 shows `disconnected` since 2026-08-18 09:04 UTC.
- No remote shell/SSH route to 192.168.111.77 is available from the stack host (client network 192.168.111.0/24 is not directly routable from this admin host; no jump host configured).
- Result: **agent-local access NOT available** -> produce exact operator steps (below) and mark blocked.

## 2. What was confirmed instead (remote evidence)

- Flood confirmed in archives: 08-16 1.39M / 08-17 1.20M / 08-18 308K (until 09:04).
- Peak hourly 127,504 docs at 01:00 UTC 08-18.
- Agent queue impact: repeated disconnects; last keepalive 09:04 UTC.
- Useful macOS rules still fire (203/204/533/5407) -> bounded predicate will preserve these.

## 3. Exact operator steps (to run on the Mac)

Full command block is in `integrations/macos/phase19-agent015-operator-steps.md`. Summary:

```bash
sudo cp /Library/Ossec/etc/ossec.conf /Library/Ossec/etc/ossec.conf.phase19.bak
# edit /Library/Ossec/etc/ossec.conf: comment out unified-log localfile (location>log), add bounded <query> block
sudo /Library/Ossec/bin/wazuh-control restart
sudo /Library/Ossec/bin/wazuh-control status
```

Before/after numbers and rollback: `integrations/macos/phase19-macos-local-ossec-config.md` and `phase19-agent015-rollback.md`.

## 4. Manager-side state (unchanged, by design)

- No change to shared ossec.conf; the fix is purely agent-local so it does not affect other clients.
- Once the Mac change is applied, agent 015 will self-apply it on next restart.

## Owner / next action

- **Owner:** operator with physical/admin access to Julians-Air.
- **On apply:** agent 015 should reconnect within ~2 min and archive volume should collapse. SOC will run Phase 19.04 validation automatically after reconnect.

## No secrets