# Drill D8: Security Onion Bridge Validation

Date: 2026-08-11
Status: **PASS (both directions validated)**

## Paths

```text
1. Wazuh -> SO: alerts forwarded as JSON syslog to 192.168.222.116:514 (csyslogd)
2. SO -> Wazuh: agent 008 (securityonion) enrolled, Active, sends events to master
3. SO -> IRIS: via Shuffle workflow security-onion-alert-to-iris (notify-only)
```

## Evidence

| Check | Status | Evidence |
|---|---|---|
| SO VM reachable | PASS | ping 0.124ms, SSH port open (192.168.222.116) |
| SO syslog sidecar | PASS | security-onion container Up 47h (healthy) |
| Wazuh -> SO forwarding | PASS | syslog_output configured to 192.168.222.116:514, JSON format; wazuh-csyslogd running |
| SO -> Wazuh (agent 008) | PASS | agent_control: 008 Active, last keepalive 1786427626 |
| SO alert flow in Wazuh | PASS | agent 008 alerts landing (osquery etc. - latest 1h) |
| SO -> IRIS route | CONFIGURED | Shuffle workflow security-onion-alert-to-iris exists (notify-only); webhook ID needs Shuffle UI confirmation |

## Test payload

Safe SO sample event stored in integrations/test-events/d8-security-onion-sample.json
for Shuffle webhook-level test (same webhook-availability caveat as D5).

## Bridge gaps

1. SO -> Shuffle -> IRIS webhook ID not re-verified this run (Shuffle webhook
   reliability dependency; manual IRIS creation documented).
2. Suricata alert ingestion into Wazuh uses the agent 008 path (journald/osquery
   visible); suricata signature alerts route through the SO alerting bridge per
   phase 2 wiring - functional test still pending a real signature hit or injected payload.

## Files

- integrations/security-onion/so-bridge-validation.md
- integrations/test-events/d8-security-onion-sample.json
