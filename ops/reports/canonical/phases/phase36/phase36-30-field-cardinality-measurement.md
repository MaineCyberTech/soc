# Phase 36: Field Cardinality Measurement

Date: 2026-08-25

## Suricata stats fields
- eve.json stats records: 522 fields
- eve-alert.json records: varies (alert records have fewer fields)
- Alert records: well under 256 fields

## Wazuh decoder
- json decoder processes eve.json
- decoder_order_size=256 limits parsed fields
- Stats events: 522 > 256 → "Too many fields" error
- Alert events: typically < 100 fields → decoded OK

## Error rate
- 15,189 total errors
- Non-fatal: events still indexed in OpenSearch

## Impact assessment
- Dashboard impact: stats data may be incomplete in Wazuh
- Alerting: UNAFFECTED (alerts have fewer fields)
- Forensics: UNAFFECTED (raw eve.json preserved)

## No secrets
