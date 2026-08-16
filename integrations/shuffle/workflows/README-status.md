# Shuffle Workflow Specs — Deployment Status

| Workflow spec | Deployed (2026-08-10) | Notes |
|---|---|---|
| wazuh-high-severity-to-iris | **YES** (workflow eb937a37-5244-46dc-95ff-62ad4c681322) | Log + IRIS alert (Critical); webhooks A + opencanary monitor |
| wazuh-flow-classb-to-iris | **YES** (workflow e951db98-9a57-4328-8344-09f8b5b9a69f) | IRIS alert (High), class:B tag; hook B |
| flow-unknown-exporter-to-case | Merged into wazuh-high-severity-to-iris | Monitor flow-unknown-exporter → webhook A |
| opencanary-hit-to-case | Merged into wazuh-high-severity-to-iris | Monitor opencanary-hit → webhook A (5 s verified) |
| critical-vuln-to-case | Merged into wazuh-high-severity-to-iris | Greenbone alert `MCT-Critical-to-Shuffle` → webhook A |
| security-onion-alert-to-iris | SUPERSEDED 2026-08-15 - SO events route via agent 008 -> Wazuh -> wazuh-high-severity-to-iris | no SO bridge needed |
| active-response-audit | Implemented as host cron instead | ops/scripts/active-response-audit.sh (Mon 06:45) |
| misp-ioc-enrichment | Spec only | Needs working Shuffle variables (${body:...} broken in this build) |
| open-enrollment-window-manual-approval | Spec only | Manual approval gate — operator-driven |
| close-enrollment-window | Spec only | Manual approval gate — operator-driven |
| monthly-report-build-trigger | Implemented as host cron instead | Scorecard cron (1st of month) |

## Summary

- 2 workflows deployed and verified end-to-end
- 3 monitoring paths merged into the Class A workflow (flow-unknown-exporter, opencanary, greenbone critical)
- 2 host crons replace schedule-based workflows (active-response audit, monthly report)
- 3 specs remain operator/manual (enrollment windows, MISP enrichment, +1) - SO bridge no longer needed (2026-08-15)
