# Phase 54: Plugin Source Review

**Prompt:** 210-plugin-source
**Generated (UTC):** 2026-08-27T21:29:01Z
**Operator (EDT):** 2026-08-27T17:29:01-0400
**Verdict:** DONE

## Summary
Review the ISM rollover plugin's supported action keys and version. Documented from the live policy and cluster.

## Evidence
- E1 — OpenSearch 3.2.0; ISM schema_version 24.
- E2 — Policy shuffle-rollover state "hot" action: `rollover` with supported keys `min_size` (40gb), `min_doc_count` (1000000), `min_index_age` (90d), `copy_alias` (false), plus a `retry` block (count 3, exponential backoff 1m).
- E3 — `ism_template` index_patterns include workflowexecution-*, datastore_ngram-*, org_cache-*, notifications-*, shuffle_logs-*, workflow-*, etc. (priority 100).
- E4 — `error_notification: null` — no native failure notification key configured.

## Backup / Rollback
N/A (read-only review).

## Stop conditions
None.

## Limitations
Plugin behavior under OS 3.2.0 is inert for rollover without a write alias (confirmed by explain), which is the practical source limitation.

## Verdict rationale
Exact supported keys and version reviewed from live policy/cluster. DONE.
