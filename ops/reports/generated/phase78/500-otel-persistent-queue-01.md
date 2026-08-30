# Phase 78: Otel Persistent Queue

**Report ID:** 500-otel-persistent-queue-01
**Phase:** 78
**Title:** Phase 78: Otel Persistent Queue
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T18:52:00Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T14:52:00-04:00
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase78/500-otel-persistent-queue-01.md
**Prompt:** 500-otel-persistent-queue-01.md

## Verdict
**PASS** — A persistent `file_storage` queue is implemented with bounded storage, correct permissions, a corruption/on-start compaction policy, and verified restart survival.

## Evidence (live, this session)
- `extensions.file_storage`: `directory: /var/lib/otel/file_storage`, `create_directory: true`, `compaction.on_start: true` (compacts/repairs on start; corrupt segments are skipped and the queue continues — bounded, self-healing).
- **Bounded storage:** `sending_queue.queue_size: 5000` batches bounds both in-memory and on-disk footprint (directory host-mounted; on-disk size bounded by queue_size x batch size).
- **Permissions:** host path `/opt/mct-security-stack/data/otel-file-storage` mounted `rw` into the container; collector runs as non-root uid 65532, so the host dir was made writable for that uid, keeping the queue writable without running the container as root.
- **Restart survival (verified):** 40 traces were enqueued while egress was blocked, the collector was restarted (`docker restart`, 12.5s, health 200), and after unblock the pre-restart queued traces were exported (e.g. trace `35b9c78899acc80aa4cd7976812e5252` -> doc `xD0CVKABomKEMWVwrwAr`). The persistent file_storage survived the restart.

## Action Performed
Config + compose edited and redeployed (see otel-queue-type). No destructive state mutated.

## Backup / Rollback
- Backups in `ops/backups/agents/phase78/`. Rollback: restore configs, remove the bind mount, `docker compose up -d`.

## Stop Conditions (BLOCKED only)
Not BLOCKED.

## Limitations
- Corruption policy relies on `compaction.on_start`; undetectable mid-segment corruption may drop a bounded number of queued items (within the queue_size bound).
- Queue volume is not replicated; host disk failure could lose queued-but-unsent telemetry.

---
*Phase 78 otel workstream — evidence-backed; secrets referenced by PATH only.*

---
*Work item 1 of 10. Phase 78 otel corpus; consistent with phase78-evidence-otel.json.*
