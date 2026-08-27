# Phase 56: Cluster Pin

**Prompt:** 215-os-cluster-pin
**Generated (UTC):** 2026-08-27T21:30:00Z
**Operator (EDT):** 2026-08-27T17:30:00-0400
**Verdict:** PARTIAL

## Summary
Read-only cluster-pin capture for BOTH OpenSearch clusters in scope. Each has a distinct, VERIFIED name/uuid/node. The prompt's target cluster is ambiguous (Wazuh indexer vs Shuffle backend); both are pinned here to avoid re-litigation.

## Evidence
- EV-OS-2 (VERIFIED) — Wazuh indexer: `cluster_name=wazuh-cluster`, `cluster_uuid=OQ_G_ZSIRZWFdJNzkoTeLA`, nodes `wazuh1.indexer`/`wazuh2.indexer`/`wazuh3.indexer` (3 nodes, green), v7.10.2. Host `127.0.0.1:9200` HTTPS.
- EV-OS-3 (VERIFIED) — Shuffle backend: `cluster_name=shuffle-cluster`, `cluster_uuid=rPikaq3wS5OYlWdyJYb8jQ`, node `shuffle-opensearch` (single node, health yellow), v3.2.0. Container `shuffle-opensearch:9200`.
- EV-OS-4 (VERIFIED): Shuffle backend indices include `datastore_category-000001` etc. → confirms this is the Shuffle datastore cluster being pinned.

## Backup / Rollback
N/A (read-only pin capture). For any future ISM/retention work, pin by `cluster_uuid` (both captured above).

## Stop conditions
No mutation. ISM/index intervention beyond scripted retention is approval-gated (AGENTS.md). Note: `shuffle-rollover` ISM is incompatible with OpenSearch 3.2.0 (Phase 53 decision ACCEPT) — do NOT retry invalid ISM on `shuffle-cluster`.

## Limitations
- Wazuh pin retrieved from host over HTTPS with creds (value never printed). Shuffle pin retrieved via in-container GET.
- `cluster.initial_master_nodes` for Shuffle backend is a single node (no HA) — pin is to one node.

## Verdict rationale
Both clusters pinned VERIFIED read-only; ambiguity of target cluster prevents an unqualified single-cluster ACCEPT → PARTIAL.
