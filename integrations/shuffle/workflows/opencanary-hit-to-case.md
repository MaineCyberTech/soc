# Workflow: opencanary-hit-to-case

- Mode: notify-only
- Trigger: Shuffle Webhook `opencanary-hit` (from Wazuh opencanary rules, syslog intake)
- Payload: `integrations/shuffle/webhook-contracts/opencanary-hit.json`

## Steps

1. Parse canary service + src IP.
2. MISP enrichment on src IP.
3. Create IRIS alert with severity 4 (Class A), template `opencanary-hit`.
4. Notify immediate channel.
5. Do NOT run active response against the canary (would reveal deception).

## Failure modes

- IRIS down -> notify channel directly + log.

## Acceptance

- Test opencanary-hit payload creates a Class A IRIS alert.
