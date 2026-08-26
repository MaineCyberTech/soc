# Phase 36: IRIS Integration Test

Date: 2026-08-25

## IRIS status
- Container: iriswebapp_nginx (port 8443)
- Workflow target: https://iriswebapp_nginx:8443/alerts/add
- Mode: notify-only

## Test
- Workflow wazuh-high-severity-to-iris calls IRIS endpoint
- Existing 796 executions: all FINISHED
- No errors in execution history

## Assessment
- IRIS integration: FUNCTIONAL (notify-only)
- No changes made

## No secrets
