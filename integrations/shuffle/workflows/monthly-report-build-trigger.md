# Workflow: monthly-report-build-trigger

- Mode: notify-only
- Trigger: Schedule (1st of month 06:00)
- Payload: none

## Steps

1. Run `generate-scorecard.example.py` (or scheduled job) against OpenSearch queries in `reporting/queries/`.
2. Render scorecard template `reporting/templates/client-scorecard.md` per client.
3. Save to `reporting/output/` with timestamp.
4. Notify ops: report ready for review (Class C).

## Failure modes

- Query fails -> report generator errors logged; notify ops; previous report retained.

## Acceptance

- Monthly output generated with placeholder data during testing.
