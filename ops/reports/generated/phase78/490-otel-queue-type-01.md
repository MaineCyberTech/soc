# Phase 78: Otel Queue Type

**Report ID:** 490-otel-queue-type-01
**Phase:** 78
**Title:** Phase 78: Otel Queue Type
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T18:52:00Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T14:52:00-04:00
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase78/490-otel-queue-type-01.md
**Prompt:** 490-otel-queue-type-01.md

## Verdict
**PASS** — The Collector sending queue is a PERSISTENT, file-backed `file_storage` queue (queue_type=`file_storage`). The restart-loss objective is explicit and was verified by a live restart test (queued telemetry survives a collector restart). Telemetry storage, retry, queue and drop behavior are bounded and measured.

## Evidence (live, this session)
- `ops/otel/collector.yaml`: `extensions.file_storage` defined (directory `/var/lib/otel/file_storage`, `create_directory: true`, `compaction.on_start: true`); `exporters.opensearch.sending_queue.storage: file_storage`, `queue_size: 5000`, `num_consumers: 10`.
- `otelcol --config` validate exit 0. Collector start log: `Extension started. name=file_storage`; created `/var/lib/otel/file_storage/exporter_opensearch__traces` + `exporter_opensearch__logs`.
- `otelcol_exporter_queue_capacity{exporter=opensearch}=5000` (explicit bound).
- **loss_objective:** queued telemetry that has entered the persistent queue survives a collector restart and is flushed on recovery (verified: 40 pre-restart queued traces delivered after restart — see otel-restart). A hard/permanent backend rejection (connection refused) is treated as non-retryable by the opensearch exporter and dropped immediately (acknowledged loss on permanent failure).

## Action Performed
Edited `collector.yaml` (added `file_storage` extension + `sending_queue.storage`) and `docker-compose.otel.yml` (host bind mount `/opt/mct-security-stack/data/otel-file-storage:/var/lib/otel:rw`); redeployed; verified healthy.

## Backup / Rollback
- Pre-edit configs backed up: `ops/backups/agents/phase78/collector.yaml.bak.20260830T184300Z`, `docker-compose.otel.yml.bak.20260830T184300Z`. Revert by restoring these and `docker compose -f compose/docker-compose.otel.yml up -d`.

## Stop Conditions (BLOCKED only)
Not BLOCKED.

## Limitations
- File-backed persistence protects against collector process/container restart and transient backend outages; it does not protect against host disk loss (no replica of the queue volume).
- A permanent backend rejection is dropped (by exporter design), not indefinitely retained.

---
*Phase 78 otel workstream — evidence-backed; secrets referenced by PATH only; OpenSearch never stopped.*

---
*Work item 1 of 10. Phase 78 otel corpus; consistent with phase78-evidence-otel.json.*
