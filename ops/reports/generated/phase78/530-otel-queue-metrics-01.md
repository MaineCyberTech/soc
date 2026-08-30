# Phase 78: Otel Queue Metrics

**Report ID:** 530-otel-queue-metrics-01
**Phase:** 78
**Title:** Phase 78: Otel Queue Metrics
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T18:52:00Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T14:52:00-04:00
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase78/530-otel-queue-metrics-01.md
**Prompt:** 530-otel-queue-metrics-01.md

## Verdict
**PASS** — The collector exposes queue/depth/drop metrics via its Prometheus endpoint, including a drop metric, confirming the queue is observable and bounded.

## Evidence (live, this session)
- `service.telemetry.metrics.level: detailed` with a Prometheus reader on `0.0.0.0:8889`.
- Verified metrics (exposed, non-secret): `otelcol_exporter_queue_capacity{exporter=opensearch}=5000`, `otelcol_exporter_queue_size{data_type=traces|logs}`, `otelcol_exporter_sent_spans`, and the drop metric **`otelcol_exporter_send_failed_spans`**.
- **drop_metric = `otelcol_exporter_send_failed_spans`** (increments on permanent drop; present/observed at the metrics endpoint; value 0 at capture because the DROP outage was treated as retryable and buffered, not dropped).
- During the outage test the live `otelcol_exporter_queue_size` was polled to derive outage_peak_depth (16) and drain_time (40.6s).

## Action Performed
No config change to metrics (already enabled in Phase 77); confirmed live exposure by polling from a network peer container.

## Backup / Rollback
- Metric configuration is part of the backed-up `collector.yaml`.

## Stop Conditions (BLOCKED only)
Not BLOCKED.

## Limitations
- The Prometheus port (8889) is not published to the host; it is scraped from the `mct-security` network. No host-external exposure.

---
*Phase 78 otel workstream — evidence-backed; secrets referenced by PATH only.*

---
*Work item 1 of 10. Phase 78 otel corpus; consistent with phase78-evidence-otel.json.*
