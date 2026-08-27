# Phase 55: Rollover Baseline

**Prompt:** 255-baseline
**Generated (UTC):** 2026-08-27T23:03:44Z
**Operator (EDT):** 2026-08-27T19:03:44-0400
**Verdict:** DONE

## Summary
Phase 55 prompt 255 (Rollover Baseline) establishes a read-only baseline of rollover failure and growth for the Shuffle datastore. Inspection was strictly read-only (GET only) against the Shuffle OpenSearch (opensearchproject/opensearch:3.2.0, security plugin disabled). The `shuffle-rollover` ISM policy exists but is incompatible with OpenSearch 3.2.0 (rejected `rollover_alias`), so it remains UNCHANGED and ACCEPT (owner-ratified P53). Datastore is healthy and small; no rollover failures observed.

## Evidence
- EV-RB1 (VERIFIED, live): Shuffle datastore `shuffle-cluster` runs OpenSearch `3.2.0` (docker image `opensearchproject/opensearch:3.2.0`; `GET /` → version 3.2.0). Confirms the run-context incompatibility basis.
- EV-RB2 (VERIFIED, live): ISM policy `shuffle-rollover` (description "Shuffle rollover policy") present on the Shuffle datastore (`GET /_plugins/_ism/policies`). Per P53/P54 it is UNCHANGED/incompatible and ACCEPT — no active rollover.
- EV-RB3 (VERIFIED, live): Largest indices are `workflow_revisions-000001` (39mb, 490 docs) and `workflowexecution-000001` (35.8mb, 1185 docs); all indices `open`, no red/unassigned shards. Daily `top_queries-*` ~3.7mb each. Growth is bounded and healthy; no rollover failure signatures.
- EV-RB4 (VERIFIED, live): Wazuh indexer (`127.0.0.1:9200`) `GET /_cluster/health` → status `green`, `number_of_nodes` 3, `unassigned_shards` 0, version 7.10.2 (separate cluster; not subject to `shuffle-rollover`).

## Backup-Rollback
No changes made (read-only). Rollback N/A. Standing decision: rollover ISM ACCEPT (P53, owner-ratified) — do not retry invalid ISM.

## Stop conditions
None encountered. Note: any manual ISM/index intervention beyond this read-only baseline would be approval-gated (run-context §4; AGENTS §Approval-Gated). Not performed.

## Limitations
- Trigger liveness (webhook RUNNING) relied on P54 carryover; Shuffle hook-listing API returned 401/405 (API quirk), not re-confirmed live this session.
- ROUTED live replay (run-context §7 harness) intentionally NOT executed to avoid IRIS object creation (mutation); P54 ROUTED preserved as VERIFIED carryover (exec `2ce46d4a` → http_status 200, destination_object_id 67).

## Verdict rationale
Read-only baseline achieved with live VERIFIED evidence. Rollover failure mode = policy incompatible (already ACCEPT, no rollover active); datastore healthy/small; growth bounded. Reported DONE.
