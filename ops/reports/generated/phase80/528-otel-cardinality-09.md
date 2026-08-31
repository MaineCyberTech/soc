# Phase 80 OTel Report — Otel Cardinality

Report ID: 528-otel-cardinality-09
Phase:80
Title: Otel Cardinality
Date:2026-08-30
Timestamp UTC Z: 2026-08-31T02:10:42Z
Timestamp ET EDT: 2026-08-30T22:10:42 EDT
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p80/prompts/528-otel-cardinality-09.md
Prompt: 528-otel-cardinality-09.md

## Result
PASS.

## Evidence
This workstream is certified against the measured evidence in
`/opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` (validator `p80-otel-validate.py` returns PASS: 18/18 required keys present and non-false).

## Summary
Cardinality controls: BEFORE = memory_limiter limit_mib=256 spike_limit_mib=64; persistent sending_queue queue_size=5000 batches; batch processor. AFTER = attribute allowlist (attributes/allowlist) is present and active, dropping sensitive/high-cardinality keys (client/source/host/net IP/port/name and any key matching .*password|secret|token|api_key|authorization|credential.*); memory_limiter and queue_size bounds unchanged.

## Method (reversible, scoped, evidence retained)
- Backend outage was scoped to the collector's export path only (a hang blackhole on the OpenSearch
  export port); the shared OpenSearch service was never stopped and `docker compose down -v` was never used.
- The persistent (file_storage) queue, byte bounds, restart behaviour, storage-full bound, and corruption
  handling were exercised on the live collector and verified with `du`, Prometheus metrics, and direct
  OpenSearch document counts. Configuration changes were reverted to the production collector config
  (collector.yaml.prod, queue_size=5000, TLS to shuffle-opensearch:9200). Secrets were read locally for
  testing only and never committed.
- Validator command: `python3 ops/scripts/p80-otel-validate.py /opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` -> {"missing_or_false": []} (exit 0).
