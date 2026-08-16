# Workflow: active-response-audit

- Mode: notify-only (reporting)
- Trigger: Schedule (weekly, e.g. Monday 06:00) or webhook
- Payload: none (queries Wazuh API / OpenSearch)

## Steps

1. Query OpenSearch for `rule.groups: active-response` over last 7 days.
2. Summarize: rule id, agent, command, count.
3. Write summary to `reporting/output/active-response-weekly.md`.
4. Notify analysts (Class C digest) if count > threshold (e.g. 10).

## Acceptance

- Weekly file produced; counts correct vs raw OpenSearch query.
