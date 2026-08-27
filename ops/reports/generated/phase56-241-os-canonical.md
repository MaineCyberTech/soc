# Phase 56: Canonical OpenSearch Endpoint Update

**Prompt:** 241-os-canonical
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** ACCEPT

## Summary
Read-only check of canonical OpenSearch endpoint. Host 127.0.0.1:9200 resolves to the Wazuh indexer, NOT the Shuffle datastore. Any canonical reference that maps 127.0.0.1:9200 to the Shuffle datastore is stale and must be corrected to point at the Shuffle opensearch service inside the docker network.

## Evidence
- EV-06 [VERIFIED]: VERIFIED - Wazuh indexer 127.0.0.1:9200 reachable (HTTP 401 auth-required); cluster_name=wazuh-cluster, ES-compat 7.10.2; indexer admin auth via WAZUH_ADMIN_PASSWORD (path /opt/wazuh-docker/multi-node/ops/creds.env) succeeds.
- EV-07 [VERIFIED]: VERIFIED - Shuffle's own datastore (shuffle-opensearch:3.2.0) is NOT published to host; host 127.0.0.1:9200 is the Wazuh indexer. Shuffle datastore ISM/capacity metrics are NOT queryable from host shell -> consistent with Phase 55 UNVERIFIED OpenSearch monitoring gap.

## Backup / Rollback
None (inspection only).

## Stop conditions
No endpoint/network mutation performed; edits to canonical docs are owner/operator changes.

## Limitations
Endpoint correction requires doc/config edit (operator-gated, non-mutating to runtime).

## Verdict rationale
ACCEPT: discrepancy identified and accepted as a documentation/canonical correction item; no runtime mutation made.
