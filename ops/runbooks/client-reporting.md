# Client Reporting Runbook

Purpose: generate MSP-ready client scorecards and internal weekly reviews from existing data sources.

## Data sources

- Wazuh alerts: `reporting/queries/wazuh-alerts.json` (index `wazuh-alerts-*`)
- Agent health: `reporting/queries/agent-health.json` (`wazuh-monitoring-*`)
- Flow summary: `reporting/queries/elastiflow-summary.json` (`elastiflow-*`)
- Vulnerabilities: `reporting/queries/vulnerabilities.json` (`wazuh-states-vulnerabilities-*`)
- SCA failures: `reporting/queries/sca-failures.json` (`wazuh-states-sca-*`)

## Generate (sample/placeholder mode)

```bash
cd /opt/mct-security-stack
python3 ops/scripts/generate-scorecard.example.py --client "Client North Parish"
# output: reporting/output/scorecard-client-north-parish-<date>.md
```

## Generate (live mode)

```bash
cd /opt/mct-security-stack
set -a; source /opt/wazuh-docker/multi-node/ops/creds.env; set +a
python3 ops/scripts/generate-scorecard.example.py --live --client "Client Long Beach Marina"
```

Secrets come from the sourced env only — never from argv or docs.

## Reporting schedule

| Report | Cadence | Owner |
|---|---|---|
| Client scorecard | Monthly (1st) | SOC lead |
| Internal weekly security review | Weekly (Mon) | SOC analyst |
| Vulnerability summary | Weekly | SOC analyst |
| Active response audit | Weekly (Shuffle workflow) | Automated |

## Views

- Client scorecard: client-facing view (exec summary, coverage, top alerts, incidents, vulns, SCA, action items).
- Internal review: full detail incl. tuning changes, pipeline health, decisions needed.
- Never mix client-specific data across scorecards; use per-client query filters when a client boundary exists.

## Quality rules

- Query files must stay valid JSON (validate: `python3 -m json.tool <file>`).
- No real secrets in reports or query files.
- Sample mode must work offline (placeholder data) — acceptance criterion.
- Report generator runs separately from Wazuh internals; only reads via the localhost indexer API.

## Failure modes

| Failure | Handling |
|---|---|
| OpenSearch query fails | Script logs error, uses sample data, report marked `DRAFT` |
| Creds missing | Live mode fails fast; use sample mode |
| Report template changed | Keep template placeholders stable; validate with a sample run |

## Acceptance

- Report generated with placeholder/sample data.
- All 5 query files valid JSON.
- No secrets embedded.
- Internal vs client views distinguished.
