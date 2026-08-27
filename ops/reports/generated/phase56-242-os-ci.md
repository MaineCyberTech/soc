# Phase 56: OpenSearch Endpoint CI

**Prompt:** 242-os-ci
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** PARTIAL

## Summary
CI gate to reject wrong protocol/UUID for the OpenSearch endpoint. Current host 127.0.0.1:9200 is the Wazuh indexer (HTTPS, auth); the Shuffle datastore uses a different service/network and is not host-exposed. A CI assertion that 127.0.0.1:9200 == Shuffle datastore would be false and should reject.

## Evidence
- EV-06 [VERIFIED]: VERIFIED - Wazuh indexer 127.0.0.1:9200 reachable (HTTP 401 auth-required); cluster_name=wazuh-cluster, ES-compat 7.10.2; indexer admin auth via WAZUH_ADMIN_PASSWORD (path /opt/wazuh-docker/multi-node/ops/creds.env) succeeds.
- EV-07 [VERIFIED]: VERIFIED - Shuffle's own datastore (shuffle-opensearch:3.2.0) is NOT published to host; host 127.0.0.1:9200 is the Wazuh indexer. Shuffle datastore ISM/capacity metrics are NOT queryable from host shell -> consistent with Phase 55 UNVERIFIED OpenSearch monitoring gap.

## Backup / Rollback
None (read-only).

## Stop conditions
No CI mutation; CI rule authoring is operator work.

## Limitations
Cannot validate Shuffle datastore UUID from host (EV-07).

## Verdict rationale
PARTIAL: Wazuh indexer endpoint VERIFIED reachable; Shuffle datastore UUID/protocol not host-assertable -> CI coverage UNVERIFIED for Shuffle DS.
