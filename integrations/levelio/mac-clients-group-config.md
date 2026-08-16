# mac-clients Group (macOS endpoints)

Date: 2026-08-16 (created)

## Purpose

Wazuh agent group for macOS client endpoints (e.g. Julians-Air / agent 015).

## Group config (shared agent.conf on manager)

```xml
<agent_config>
  <!-- macOS unified logging collection -->
  <localfile>
    <location>macos</location>
    <log_format>macos</log_format>
  </localfile>
</agent_config>
```

## Members

| Agent | Hostname | OS | Status |
|---|---|---|---|
| 015 | Julians-Air | macOS | active |

## Notes

- Group created on manager filesystem (/var/ossec/etc/shared/mac-clients),
  synced via cluster; agent assigned via API.
- Level.io actions for macOS endpoints should pass WAZUH_AGENT_GROUP=mac-clients.

## No secrets
