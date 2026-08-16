# Workflow: open-enrollment-window-manual-approval

- Mode: manual approval REQUIRED
- Trigger: Operator webhook/button
- Payload: `{action: "open", duration_minutes: 30}`

## Steps

1. User Input gate: operator confirms opening the Wazuh enrollment window.
2. If approved: enable Wazuh agent enrollment (call Wazuh API to set `enrollment` window / open firewall range as configured in the existing enrollment-window runbook).
3. Log to IRIS case + ops report.
4. If denied: end, log.

## Acceptance

- Gate cannot be bypassed; audit log written.
