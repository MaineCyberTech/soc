# Phase 78: Otel Restart

**Report ID:** 520-otel-restart-01
**Phase:** 78
**Title:** Phase 78: Otel Restart
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T18:52:00Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T14:52:00-04:00
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase78/520-otel-restart-01.md
**Prompt:** 520-otel-restart-01.md

## Verdict
**PASS** — A collector restart was performed and the persistent queue's restart-survival behavior was verified (consistent with the documented loss_objective).

## Evidence (live, this session)
- 40 traces were enqueued into the persistent `file_storage` queue while the collector's egress to OpenSearch was blocked.
- `docker restart mct-otel-collector` completed in **12.5 s**; health endpoint `127.0.0.1:13133` returned **200**.
- The `file_storage` bind mount (`/opt/mct-security-stack/data/otel-file-storage:/var/lib/otel`) persisted across the restart, so queued telemetry was retained.
- After unblocking egress, the **pre-restart queued traces were exported** (e.g. trace `35b9c78899acc80aa4cd7976812e5252` -> doc `xD0CVKABomKEMWVwrwAr`). Final `otelcol_exporter_queue_size=0`.
- **Conclusion:** queued telemetry survives a collector restart (loss_objective satisfied).

## Action Performed
`docker restart mct-otel-collector`; verified healthy and that queued data resumed export. Reversible and non-destructive.

## Backup / Rollback
- Backups in `ops/backups/agents/phase78/`. Restart is natively reversible; config unchanged by restart.

## Stop Conditions (BLOCKED only)
Not BLOCKED.

## Limitations
- Restart was on the same host with the same queue volume; cross-host / disk-loss restart recovery is out of scope (queue volume not replicated).

---
*Phase 78 otel workstream — evidence-backed; secrets referenced by PATH only.*

---
*Work item 1 of 10. Phase 78 otel corpus; consistent with phase78-evidence-otel.json.*
