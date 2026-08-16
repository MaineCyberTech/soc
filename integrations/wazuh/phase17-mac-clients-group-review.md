# Phase 17 mac-clients Group Review

Date: 2026-08-16

## Group config (agent.conf)

```xml
<agent_config>
  <localfile>
    <log_format>macos</log_format>
    <location>macos</location>
  </localfile>
</agent_config>
```

## Notes

- macOS unified logging = verbose; initial activation replays history (flood).
- Steady state low on idle workstations.
- All macos entries map to rule 1002 (level 0) - archive-only, no alert spam.
- Queue-full was activation-burst only.

## No secrets
