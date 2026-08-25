# Phase 34 Canary Routing Enable

Date: 2026-08-25

## Implementation
- Canary route: SID 2027967 -> Wazuh test group "suricata-alerts-test"
- Config: suricata-alerts test-group target (not production)
- Verification: configuration syntax check passed

## Test
- wazuh-logtest: SID 2027967 decodes to "Suricata: Alert" (level 3, groups [ids, suricata])
- Route path: Suricata -> eve-alert.json -> agent 016 -> Wazuh -> test group

## Blocker
- **Agent 016 ossec.conf only monitors eve-alert.json** (not eve.json)
- eve-alert.json is created on-demand when alerts fire
- For 0 live alerts: no forwarding occurs (correct behavior)
- For canary E2E: synthetic trigger must fire an alert to create eve-alert.json entry

## Rollback
- Remove test group target from canary config
- Restore observe-only posture

## No secrets
