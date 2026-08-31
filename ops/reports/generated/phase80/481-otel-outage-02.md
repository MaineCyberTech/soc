# Phase 80 OTel Report — Otel Outage

Report ID: 481-otel-outage-02
Phase:80
Title: Otel Outage
Date:2026-08-30
Timestamp UTC Z: 2026-08-31T02:10:42Z
Timestamp ET EDT: 2026-08-30T22:10:42 EDT
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p80/prompts/481-otel-outage-02.md
Prompt: 481-otel-outage-02.md

## Result
PASS.

## Evidence
This workstream is certified against the measured evidence in
`/opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` (validator `p80-otel-validate.py` returns PASS: 18/18 required keys present and non-false).

## Summary
Scoped backend outage (export path blackholed, OpenSearch left running) exercised. 100001 spans queued; peak_items=100001; peak_bytes=35012608 (~33 MiB on disk); drop_count=0 (within capacity, queue_size=5000). After backend recovery the queue drained to empty and delta into ss4o_traces-otel-mct-soc = 100001 (drain_seconds=7). Class-A spans queued during the outage were exported after recovery (classa_independent).

## Method (reversible, scoped, evidence retained)
- Backend outage was scoped to the collector's export path only (a hang blackhole on the OpenSearch
  export port); the shared OpenSearch service was never stopped and `docker compose down -v` was never used.
- The persistent (file_storage) queue, byte bounds, restart behaviour, storage-full bound, and corruption
  handling were exercised on the live collector and verified with `du`, Prometheus metrics, and direct
  OpenSearch document counts. Configuration changes were reverted to the production collector config
  (collector.yaml.prod, queue_size=5000, TLS to shuffle-opensearch:9200). Secrets were read locally for
  testing only and never committed.
- Validator command: `python3 ops/scripts/p80-otel-validate.py /opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` -> {"missing_or_false": []} (exit 0).
