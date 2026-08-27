# Phase 53: Plugin Version

**Prompt:** 175-plugin-version
**Generated (UTC):** 2026-08-27T20:07:04Z
**Operator (EDT):** 2026-08-27T16:07:04-0400
**Verdict:** DONE

## Summary
Records the exact index-management build in use.

## Evidence
- E1: OpenSearch cat plugins — `opensearch-index-management 3.2.0.0` (alongside the 3.2.0.0 plugin
  set, i.e. OpenSearch 3.2.0).
- E2: ISM policy `shuffle-rollover` is served by this plugin (total_policies=1).

## Backup / Rollback
N/A — read-only.

## Limitations
None material; version read directly from the cluster.

## Verdict rationale
Exact build captured (3.2.0.0). Marked DONE.
