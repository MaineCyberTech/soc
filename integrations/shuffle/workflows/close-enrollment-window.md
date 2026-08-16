# Workflow: close-enrollment-window

- Mode: manual approval REQUIRED
- Trigger: Operator webhook/button, or schedule at window end
- Payload: `{action: "close"}`

## Steps

1. Verify current window state.
2. User Input gate: operator confirms closing.
3. If approved: close enrollment (Wazuh API), log.
4. Notify: window closed.

## Acceptance

- Closing requires approval; state logged.
