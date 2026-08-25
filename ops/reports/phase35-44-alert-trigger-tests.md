# Phase 35: Alert Trigger Tests

Date: 2026-08-25

## Tests executed

| Test | Result | Details |
|---|---|---|
| Synthetic EVE alert injection | PASS | Rule 86601 fired, alert indexed (074hOqABXUSVSG3Wg9Bi) |
| Real SPAN alert | PASS | SID 2210038 indexed (pb4OOqABXUSVSG3WrK_C) |
| Logcollector eve.json forwarding | PASS | 14 events, 109KB |
| Logcollector eve-alert.json forwarding | PASS | 1 event, 666 bytes |
| Wazuh JSON decode | PASS | json decoder, rule 86601 match |
| OpenSearch indexing | PASS | wazuh-alerts-4.x-2026.08.25 |

## Trigger behavior
- firedtimes=1 for both rule 86601 alerts (first fire, no suppression)
- Level 3 alerts — informational severity
- No active response triggered (disabled by default)

## No secrets
