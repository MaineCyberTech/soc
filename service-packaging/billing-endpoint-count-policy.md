# Billing Endpoint Count Policy (Phase 9)

## Counting rules

1. **Billable endpoints** = Wazuh agents with status `active`, excluding:
   - wazuh.master (000)
   - lab/pilot endpoints (documented as internal)
   - never_connected agents
2. Count source: Wazuh API (agents endpoint) + agent_control, run via
   ops/scripts/endpoint-count-report.sh.
3. Velociraptor clients: counted per enrolled client; included in the endpoint
   tier (not separate billing unless packaged separately).
4. Group membership determines client attribution: `client-<slug>` group = client.

## Categories

| Category | Definition | Billing |
|---|---|---|
| Managed endpoint | active agent, client-<slug> group | per endpoint/month |
| SIEM/alerting | per client org | flat/month |
| Vulnerability mgmt | per scanned target | per target/month |
| Deception (canary) | per canary host/token | per item/month |
| DFIR (Velociraptor) | per hunt/retainer | as packaged |

## Monthly process

1. Run endpoint-count-report.sh on the 1st.
2. Verify counts vs level.io device groups.
3. Generate invoice summary (billing categories + counts).
4. Store in service-packaging/monthly-billing-review-template.md.

## Audit

- Counts auditable via Wazuh API (agents) and Velociraptor API (clients).
- Never include secrets in billing artifacts.

## No secrets

No secret values printed.
