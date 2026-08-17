# Phase 18 Suricata EVE LocalFile

Date: 2026-08-17

## ossec.conf localfile (agent 008)

```xml
<localfile>
  <location>/nsm/suricata/eve.json</location>
  <log_format>json</log_format>
</localfile>
```

## Rotation strategy

- SO writes timestamped eve files; symlink eve.json -> newest (hourly cron
  update-eve-symlink.sh).

## Decoder

- Built-in json decoder extracts alert.*, src/dest IP/port (verified logtest).

## No secrets
