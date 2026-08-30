# OpenSearch Runtime ID — True Snapshot Reconstruction (Phase 78)

**Report ID:** phase78-opensearch-runtime-id-01
**Phase:** 78
**Title:** OpenSearch Runtime ID — True Snapshot Reconstruction (Phase 78)
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T19:32:14Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T15:32:14 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /home/user/mct-p78/prompts/200-opensearch-runtime-id-01.md
**Prompt:** 200-opensearch-runtime-id-01.md

## Verdict
PASS — OpenSearch dedup index was reconstructed via a TRUE snapshot-based runtime rebuild (register repo, snapshot, DELETE, RESTORE), not a temporary reindex. opensearch_runtime_type=snapshot.

## Evidence
- Snapshot repository 'p78_repo' (fs) registered at /usr/share/opensearch/snapshots; path.repo set in opensearch.yml and opensearch restarted to apply (backup of opensearch.yml saved to ops/backups/agents/opensearch.yml-20260830T192136Z.bak).
- Snapshot 'p78_snap_20260830t192428' created of wazuh-iris-dedup-000001 (state SUCCESS).
- Index DELETEd (confirmed 404), then RESTORED from the snapshot (accepted:true). After restore: count=1, 11-field mapping identical (alert_id,claimed_ts,event_id,id,marker,phase,source_id,state,status,ts,x), cluster yellow/healthy.
- opensearch_runtime_type recorded as 'snapshot' (not 'reindex').

## Action
DELETE + RESTORE from snapshot; verified mapping preservation and health post-restore.

## Backup-Rollback
Snapshot p78_snap_20260830t192428 retained as durable runtime backup; true_rollback re-restored same snapshot into a temp index and deleted it.

## Stop-Conditions
Would STOP if RESTORE failed or mapping diverged.

## Limitations
Single-node cluster (yellow) by design; no multi-node replication tested.
