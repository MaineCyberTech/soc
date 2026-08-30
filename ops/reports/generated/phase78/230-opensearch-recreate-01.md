# OpenSearch Recreate — Delete + Restore from Snapshot (Phase 78)

**Report ID:** phase78-opensearch-recreate-01
**Phase:** 78
**Title:** OpenSearch Recreate — Delete + Restore from Snapshot (Phase 78)
**Date:** 2026-08-30
**Timestamp:** 2026-08-30T19:32:14Z (UTC)
**Timestamp (America/New_York):** 2026-08-30T15:32:14 EDT
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** /home/user/mct-p78/prompts/230-opensearch-recreate-01.md
**Prompt:** 230-opensearch-recreate-01.md

## Verdict
PASS — True runtime recreation: index destroyed and rebuilt from snapshot; mapping + doc count preserved; healthy.

## Evidence
- opensearch_before: status=yellow; docs=1; 11 mapping fields captured.
- DELETE wazuh-iris-dedup-000001 -> acknowledged true (later GET 404).
- RESTORE _snapshot/p78_repo/p78_snap_20260830t192428/_restore -> accepted true.
- opensearch_after: status=yellow; docs=1; restored_from_snapshot=p78_snap_20260830t192428; 11-field mapping identical; healthy.

## Action
DELETE then RESTORE (not reindex) to rebuild runtime state.

## Backup-Rollback
Snapshot available to re-restore if needed.

## Stop-Conditions
Would STOP if post-restore mapping differed or index unhealthy.

## Limitations
Single-node; yellow expected.
