# Phase 80 OTel Report — Otel Size Bound

Report ID: 469-otel-size-bound-10
Phase:80
Title: Otel Size Bound
Date:2026-08-30
Timestamp UTC Z: 2026-08-31T02:10:42Z
Timestamp ET EDT: 2026-08-30T22:10:42 EDT
Classification: INTERNAL
Status: PASS
Source Path: /home/user/mct-p80/prompts/469-otel-size-bound-10.md
Prompt: 469-otel-size-bound-10.md

## Result
PASS.

## Evidence
This workstream is certified against the measured evidence in
`/opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` (validator `p80-otel-validate.py` returns PASS: 18/18 required keys present and non-false).

## Summary
Explicit byte bounds are enforced. This collector build (0.118.0) has NO file_storage `max_size` field (validated: 'invalid keys: max_size'), so the byte ceiling is enforced at the filesystem layer. max_size_bytes=16777216 (16 MiB) enforced via a size-limited queue filesystem; filesystem_budget_bytes=74498920448 (host free space on the data volume). alert_threshold_bytes=8388608 (8 MiB) implemented in ops/otel/queue-watch.sh which exits non-zero when the queue exceeds the threshold. queue_capacity_items=5000 (sending_queue queue_size batches).

## Method (reversible, scoped, evidence retained)
- Backend outage was scoped to the collector's export path only (a hang blackhole on the OpenSearch
  export port); the shared OpenSearch service was never stopped and `docker compose down -v` was never used.
- The persistent (file_storage) queue, byte bounds, restart behaviour, storage-full bound, and corruption
  handling were exercised on the live collector and verified with `du`, Prometheus metrics, and direct
  OpenSearch document counts. Configuration changes were reverted to the production collector config
  (collector.yaml.prod, queue_size=5000, TLS to shuffle-opensearch:9200). Secrets were read locally for
  testing only and never committed.
- Validator command: `python3 ops/scripts/p80-otel-validate.py /opt/mct-security-stack/ops/reports/evidence/phase80/phase80-evidence-otel.json` -> {"missing_or_false": []} (exit 0).
