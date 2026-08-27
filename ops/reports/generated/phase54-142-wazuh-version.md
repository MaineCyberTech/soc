# Phase 54: Wazuh Version

**Prompt:** 142-wazuh-version
**Generated (UTC):** 2026-08-27T21:28:55Z
**Operator (EDT):** 2026-08-27T17:28:55-0400
**Verdict:** DONE

## Summary
Manager, worker, integratord and indexer versions captured.

## Evidence
- E1 — docker images: multi-node-wazuh.master-1, worker-1 = wazuh-manager:4.14.7; multi-node-wazuh1/2/3.indexer-1 = wazuh-indexer:4.14.7.
- E2 — integratord is bundled within wazuh-manager 4.14.7 (no separate version).

## Backup / Rollback
N/A.

## Stop conditions
None.

## Limitations
None.

## Verdict rationale
Version baseline captured read-only.
