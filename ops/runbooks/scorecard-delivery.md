# Scorecard Delivery Runbook

## Reports

| Report | Source | Output |
|---|---|---|
| Internal SOC scorecard | generate-monthly-scorecard.py --live | reporting/output/internal/phase4-internal-soc-scorecard.md |
| Client scorecard | same script --client "X" | reporting/output/client/<slug>.md |
| Alert quality report | generate-alert-quality-report.py --live | reporting/output/internal/phase4-alert-quality-report.md |

## Generation

```bash
# internal (live, needs WAZUH_ADMIN_PASSWORD in env - never argv)
WAZUH_ADMIN_PASSWORD=<redacted> python3 ops/scripts/generate-monthly-scorecard.py --live

# client
WAZUH_ADMIN_PASSWORD=<redacted> python3 ops/scripts/generate-monthly-scorecard.py --live --client "North Parish"

# alert quality
WAZUH_ADMIN_PASSWORD=<redacted> python3 ops/scripts/generate-alert-quality-report.py --live
```

## Client-safe conversion

Before sending any client report:

1. Replace internal hostnames/IPs with site labels (redaction-standard.md).
2. Remove internal tool names where sensitive (Shuffle/IRIS internals) - keep
   outcome language.
3. Verify no secret values (scan-docs-for-secret-patterns.sh).
4. Add classification banner: CLIENT CONFIDENTIAL.

## Cadence

- Internal: monthly (1st business day)
- Client: monthly per client, after internal review
- Alert quality: monthly with internal

## Delivery

- Internal: ops drive / internal docs folder.
- Client: secure channel per client (encrypted email/portal); no credentials embedded.

## Standard outputs

- internal/phase4-internal-soc-scorecard.md (live: 1,949,758 alerts/30d, Class A 446)
- internal/phase4-alert-quality-report.md (live)
- client/phase4-client-scorecard-template.md (template with placeholders)
