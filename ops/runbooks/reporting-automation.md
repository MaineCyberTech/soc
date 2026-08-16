# Reporting Automation Runbook

## Reports

| Report | Script | Template | Cadence |
|---|---|---|---|
| Internal weekly SOC review | manual (from healthcheck + alerts) | internal-weekly-soc-review.md | weekly |
| Monthly MCT scorecard | generate-monthly-scorecard.py | monthly-client-scorecard.md | monthly |
| Client monthly scorecard | generate-monthly-scorecard.py --client X | monthly-client-scorecard.md | monthly |
| Vulnerability review | manual (Greenbone export) | vulnerability-review.md | monthly |
| Incident/case summary | manual (IRIS case export) | (client-scorecard fields) | monthly |
| Alert quality report | generate-alert-quality-report.py | alert-quality-report.md | monthly |
| Full-stack health | full-stack-healthcheck.sh | full-stack-health-latest.md | hourly/daily |

## Run modes

```bash
# Sample/dry-run - no credentials needed
python3 ops/scripts/generate-monthly-scorecard.py
python3 ops/scripts/generate-alert-quality-report.py

# Live (requires WAZUH_ADMIN_PASSWORD in environment, never argv)
WAZUH_ADMIN_PASSWORD=... python3 ops/scripts/generate-monthly-scorecard.py --live --client "North Parish"
WAZUH_ADMIN_PASSWORD=... python3 ops/scripts/generate-alert-quality-report.py --live
```

## Data sources

- Wazuh alerts/archives (indexer 9200, admin creds from env)
- Wazuh agent health (agent_control / agent-health.json query)
- ElastiFlow summaries (elastiflow-summary.json query)
- IRIS cases (API - requires IRIS API key env, not yet wired)
- Greenbone findings (gvm-cli export, manual)
- MISP IOC matches (CDB + alert counts)
- OpenCanary hits (121012 counts)
- Backup/DR freshness (backup-freshness-check.sh)

## Output dirs

- `reporting/output/` - generated reports (internal + client)
- `reporting/queries/*.json` - saved OpenSearch queries (no secrets)
- Client reports: name with client slug + date; keep per-client subfolder if client count grows.

## Security

- Queries contain no credentials (indexer auth via env at runtime).
- Client reports: no internal hostnames, no secret values; use <REDACTED_HOST> per redaction standard.
- Never commit reporting/output to git.

## Automation

- Suggested: add to root crontab monthly:

```cron
30 6 1 * * cd /opt/mct-security-stack && WAZUH_ADMIN_PASSWORD=$(grep '^WAZUH_ADMIN_PASSWORD' ops/creds.env | cut -d= -f2-) python3 ops/scripts/generate-monthly-scorecard.py --live >> ops/reports/scorecard-cron.log 2>&1
```

Not installed by default - operator approval required.
