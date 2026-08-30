# Phase 78: Otel Backend Outage

**Report ID:** 510-otel-backend-outage-01
**Phase:** 78
**Title:** Phase 78: Otel Backend Outage
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T18:52:00Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T14:52:00-04:00
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase78/510-otel-backend-outage-01.md
**Prompt:** 510-otel-backend-outage-01.md

## Verdict
**PASS** — A backend (OpenSearch) outage was simulated from the collector's perspective WITHOUT stopping OpenSearch, the backlog and recovery were measured, and Class-A delivery remained independent.

## Evidence (live, this session)
- **Outage method (source-specific, reversible):** host `iptables -I DOCKER-USER -s 172.20.0.18 -d 172.20.0.3 -p tcp --dport 9200 -j DROP` — blocks ONLY the collector's egress to OpenSearch; OpenSearch itself kept running and serving all other clients.
- 80 OTLP traces injected during a 71s outage window.
- **outage_peak_depth = 16** trace batches (max observed `otelcol_exporter_queue_size{data_type=traces}` while blocked).
- **drain_time = 40.6 s** — after removing the DOCKER-USER rule, the queue reached 0 (`otelcol_exporter_queue_size=0`) 40.6s later.
- **Delivery confirmed:** one injected trace (`7b7c80094df7b6a9cbab5292b206c0e7`) present in `ss4o_traces-otel-mct-soc` (doc `Wz0CVKABomKEMWVwEwCq`) after recovery.
- **classa_independent:** during the outage a Class-A Wazuh->IRIS webhook canary POST to `http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000-555f-4e81-9497-77b7c91c5b98` returned **HTTP 200** (trigger accepted). Shuffle->IRIS path is architecturally independent of the telemetry collector egress.

## Action Performed
Added and later removed the DOCKER-USER egress block. No production data deleted.

## Backup / Rollback
- The egress block is fully reversible (rule removed and verified absent). Collector healthy (200) and exporting post-test.

## Stop Conditions (BLOCKED only)
Not BLOCKED.

## Limitations
- Error classification note: the opensearch exporter treats a hard `connection refused` (REJECT) as a permanent/non-retryable error and drops immediately; a timeout-style block (DROP) is treated as retryable and buffered. The outage test used DROP to exercise the persistent queue backlog.
- Drain time is measured under a synthetic ~80-trace burst; production drain time scales with backlog volume.

---
*Phase 78 otel workstream — evidence-backed; secrets referenced by PATH only; OpenSearch never stopped.*

---
*Work item 1 of 10. Phase 78 otel corpus; consistent with phase78-evidence-otel.json.*
