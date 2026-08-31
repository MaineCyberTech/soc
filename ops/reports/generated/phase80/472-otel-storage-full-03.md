# Phase 80 OTel Report — Otel Storage Full

Report ID: 472-otel-storage-full-03
Phase:80
Title: Otel Storage Full
Date:2026-08-30
Timestamp UTC Z: 2026-08-31T02:10:42Z
Timestamp ET EDT: 2026-08-30T22:10:42 EDT
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p80/prompts/472-otel-storage-full-03.md
Prompt: 472-otel-storage-full-03.md

## Result
PASS.

## Evidence
This workstream is certified against the measured evidence in
`/opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` (validator `p80-otel-validate.py` returns PASS: 18/18 required keys present and non-false).

## Summary
Storage-full proven: the collector was run with a 16 MiB size-limited tmpfs on the queue directory and a backend hang blackhole. The queue reached the 16 MiB OS-enforced bound and the collector logged 'write .../exporter_opensearch__traces: no space left on device'. Items beyond the bound are dropped (not silently lost) and the queue shows no unbounded growth. Acknowledged (already-exported) data in OpenSearch is unaffected.

## Method (reversible, scoped, evidence retained)
- Backend outage was scoped to the collector's export path only (a hang blackhole on the OpenSearch
  export port); the shared OpenSearch service was never stopped and `docker compose down -v` was never used.
- The persistent (file_storage) queue, byte bounds, restart behaviour, storage-full bound, and corruption
  handling were exercised on the live collector and verified with `du`, Prometheus metrics, and direct
  OpenSearch document counts. Configuration changes were reverted to the production collector config
  (collector.yaml.prod, queue_size=5000, TLS to shuffle-opensearch:9200). Secrets were read locally for
  testing only and never committed.
- Validator command: `python3 ops/scripts/p80-otel-validate.py /opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` -> {"missing_or_false": []} (exit 0).
