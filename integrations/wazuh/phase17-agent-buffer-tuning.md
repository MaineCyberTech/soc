# Phase 17 Agent Buffer Tuning

Date: 2026-08-16

## Decision: source-selection fix (no buffer change needed)

| Agent | Issue | Fix | Result |
|---|---|---|---|
| 015 (macOS) | unified-logging stream overflow | bounded syslog localfile | queue-full 0 |
| 014 (Windows) | minor bursts | none (monitor) | - |
| 013 (Windows) | power-off reconnect burst | none (monitor) | - |
| 008 (SO) | zeek-forward bursts | monitor (P17.09) | - |

## macOS config (mac-clients group agent.conf)

```xml
<agent_config>
  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/system.log</location>
  </localfile>
</agent_config>
```

## If queue-full recurs

1. Increase agent queue in ossec.conf (client block): memory/queue_size.
2. Or filter noisy sources at the source.
3. Document before/after; re-measure.

## No secrets
