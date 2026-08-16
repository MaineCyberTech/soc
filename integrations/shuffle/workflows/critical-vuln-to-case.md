# Workflow: critical-vuln-to-case

- Mode: notify-only
- Trigger: Shuffle Webhook `critical-vuln` (Greenbone API pull or Wazuh vuln detector rules)
- Payload: `integrations/shuffle/webhook-contracts/greenbone-critical.json`

## Steps

1. Extract CVE + asset + CVSS.
2. Check internet-facing list (static allowlist in Shuffle variables: 138.197.105.82, 192.168.222.149, 192.168.222.116, gateways).
3. If internet-facing -> IRIS alert severity 4 (Class A), template `critical-vulnerability`, notify.
4. Else -> IRIS alert severity 2 (Class B), same-day review list.
5. Log to report.

## Failure modes

- Greenbone pull fails -> nothing to process; alert on missing scan in healthcheck.

## Acceptance

- Test payload with internet-facing asset creates Class A case.
