# Shuffle Approval Gates

Purpose: every blocking or response action in Shuffle requires explicit operator approval until validated.

## Rule

No workflow action may drop traffic, disconnect an agent, modify firewall rules, or push blocks without a manual approval gate. Default state for every new workflow: notify-only.

## Gate pattern

```text
[Trigger] -> [Parse payload] -> [Classify (A/B/C/D)] -> [Notify analyst] -> [User Input: approve?]
   -> approved: [Execute action] -> [Log result to IRIS case]
   -> denied/cancel: [Log decision] -> [End]
```

- Shuffle `User Input` node pauses the workflow until an operator responds (in UI or via webhook).
- All gate responses are written to the IRIS case timeline and to the workflow logs.
- Gates have a timeout (default 2h) — timeout defaults to deny for blocking actions, approve for notify-only.

## Initial workflow status

| Workflow | Mode | Gate required |
|---|---|---|
| wazuh-high-severity-to-iris | notify-only | No (case creation is safe) |
| flow-unknown-exporter-to-case | notify-only | No |
| opencanary-hit-to-case | notify-only | No |
| critical-vuln-to-case | notify-only | No |
| active-response-audit | notify-only | No |
| misp-ioc-enrichment | notify-only | No |
| security-onion-alert-to-iris | notify-only | No |
| open-enrollment-window-manual-approval | manual | Yes |
| close-enrollment-window | manual | Yes |
| monthly-report-build-trigger | notify-only | No |

## Enabling a blocking action

1. Document the action + test plan in the workflow spec.
2. Run in notify-only mode for >= 2 weeks.
3. Enable gate in `requires_approval: true` with `default: deny`.
4. Log the change in `ops/reports`.
5. Keep the ability to revert (rollback section per workflow).

## Audit

- `active-response-audit` workflow collects Wazuh active response events weekly and logs them to a report + IRIS.
- Gate approvals are logged with operator identity (Shuffle user) and timestamp.
