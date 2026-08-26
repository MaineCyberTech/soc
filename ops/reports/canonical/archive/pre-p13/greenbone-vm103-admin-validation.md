# Greenbone VM103 Admin Validation

Date: 2026-08-11
Status: **CREDENTIALS PRESENT + gvmd HEALTHY - schedule creation pending operator (no GMP CLI on VM)**

## Findings

| Check | Result |
|---|---|
| gvmd container | Up 39h (healthy) |
| gsad (web UI) | Up 39h |
| Admin credential | GREENBONE_ADMIN_PASSWORD present in /opt/mct-security-stack/.env (0600, not printed) |
| GMP CLI (gvm-cli) | NOT installed on VM103 host or in gvmd container - schedule creation via CLI unavailable |
| Web UI path | GSA at https://<vm103>:443 (login with admin + GREENBONE_ADMIN_PASSWORD) |

## Schedule creation paths (operator)

1. **GSA web UI** (recommended): login -> Configuration -> Schedules -> New
   (MCT-core-infra-monthly per scan-schedule-phase4.md).
2. **Install gvm-cli on VM103**: apt install greenbone-common-tools (or use
   openvas-cli package) -> gvm-cli socket --gmp-username admin --gmp-password $GREENBONE_ADMIN_PASSWORD.

## Critical alert (D5)

- After schedule: Configuration -> Alerts -> New -> severity >= 9.0 ->
  HTTP POST to Shuffle webhook (per greenbone-alert-webhook-config.md).
- Webhook URL: http://shuffle-frontend/api/v1/hooks/webhook_<trigger-id>
  (reuse wazuh-high-severity trigger until dedicated workflow created).

## No invasive actions

- Read-only checks only; no scans launched.
- No credentials printed.
