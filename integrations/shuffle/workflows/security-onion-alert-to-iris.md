# Workflow: security-onion-alert-to-iris

- Mode: notify-only
- Trigger: Wazuh alert from agent 008 (Security Onion) - zeek-forward.log intake (ZEEK-tagged conn.log) or suricata eve.json, routed via wazuh-high-severity-to-iris workflow
- Payload: `integrations/payload-contracts/wazuh-high-severity.json` (source=security-onion)

## Steps

1. Parse Suricata signature id, category, src/dst.
2. MISP enrichment.
3. If category exploitation/C2 or level high -> IRIS alert severity 4 (Class A).
4. Else IRIS alert severity 2 (Class B), tag source:security-onion.

## Failure modes

- Bridge down -> no events; healthcheck checks bridge liveness.

## Acceptance

- Test Suricata payload creates IRIS alert with correct severity.
