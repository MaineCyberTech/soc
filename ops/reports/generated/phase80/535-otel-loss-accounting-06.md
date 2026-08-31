# Phase 80 OTel Report — Otel Loss Accounting

Report ID: 535-otel-loss-accounting-06
Phase:80
Title: Otel Loss Accounting
Date:2026-08-30
Timestamp UTC Z: 2026-08-31T02:10:42Z
Timestamp ET EDT: 2026-08-30T22:10:42 EDT
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p80/prompts/535-otel-loss-accounting-06.md
Prompt: 535-otel-loss-accounting-06.md

## Result
PASS.

## Evidence
This workstream is certified against the measured evidence in
`/opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` (validator `p80-otel-validate.py` returns PASS: 18/18 required keys present and non-false).

## Summary
Loss accounting: during the bounded outage, 100001 spans were queued and all 100001 exported after recovery (delta=100001, drop_count=0) — no silent loss of acknowledged/in-flight data. Storage-full drops are bounded at the 16 MiB byte ceiling (logged 'no space', not silent). Corruption is detected ('invalid database') rather than silently dropping acknowledged data. sensitive_scan_clean=true: queue files and metrics contain no cleartext secret values (api_key/token/password/authorization); the allowlist stripped an injected user.password attribute.

## Method (reversible, scoped, evidence retained)
- Backend outage was scoped to the collector's export path only (a hang blackhole on the OpenSearch
  export port); the shared OpenSearch service was never stopped and `docker compose down -v` was never used.
- The persistent (file_storage) queue, byte bounds, restart behaviour, storage-full bound, and corruption
  handling were exercised on the live collector and verified with `du`, Prometheus metrics, and direct
  OpenSearch document counts. Configuration changes were reverted to the production collector config
  (collector.yaml.prod, queue_size=5000, TLS to shuffle-opensearch:9200). Secrets were read locally for
  testing only and never committed.
- Validator command: `python3 ops/scripts/p80-otel-validate.py /opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` -> {"missing_or_false": []} (exit 0).
