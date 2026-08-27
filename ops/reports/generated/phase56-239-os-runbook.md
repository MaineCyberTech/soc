# Phase 56: OpenSearch Runbook

**Prompt:** 239-os-runbook
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Recorded the correct endpoints for operating/monitoring the Shuffle OpenSearch datastore.

## Evidence
- EV-OS-RB-1 (VERIFIED): **Correct datastore endpoint (in-network):** `http://shuffle-opensearch:9200` on the `mct-security` overlay. Reachable from in-network tasks (e.g. `shuffle-tools`) with HTTP 200.
- EV-OS-RB-2 (VERIFIED): **Host-transient endpoint:** `http://172.20.0.8:9200` (dynamic container IP; do not hard-code). Returns HTTP 200 anonymous.
- EV-OS-RB-3 (VERIFIED, SEPARATE): **NOT the datastore:** `127.0.0.1:9200` is the Wazuh indexer (plaintext empty reply; https 401). Must not appear in Shuffle-OS runbooks/monitors.
- EV-OS-RB-4 (VERIFIED): Cluster identity for runbook pinning: `cluster_name: shuffle-cluster`, `cluster_uuid: rPikaq3wS5OYlWdyJYb8jQ`, version `opensearch 3.2.0`.

## Backup/Rollback
Read-only; no changes.

## Stop conditions
None. Correcting any deployed runbook/monitor text is a documentation/config change (see 235, DEFERRED) and was NOT executed here.

## Limitations
Endpoint list is live-verified; a published runbook file edit is out of scope for this read-only pass.

## Verdict rationale
Correct endpoints identified and separated from the Wazuh indexer. DONE (analysis; enactment of any runbook edit deferred).
