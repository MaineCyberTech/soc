# Phase 56: OpenSearch Evidence Bundle (Hashes)

**Prompt:** 243-os-evidence
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** PARTIAL

## Summary
Evidence bundle / hashing of OpenSearch artifacts. Wazuh indexer is reachable and hashable via API _stats; the Shuffle datastore is not host-reachable so index-level hashes cannot be computed from the host (consistent with P55 UNVERIFIED).

## Evidence
- EV-06 [VERIFIED]: VERIFIED - Wazuh indexer 127.0.0.1:9200 reachable (HTTP 401 auth-required); cluster_name=wazuh-cluster, ES-compat 7.10.2; indexer admin auth via WAZUH_ADMIN_PASSWORD (path /opt/wazuh-docker/multi-node/ops/creds.env) succeeds.
- EV-07 [VERIFIED]: VERIFIED - Shuffle's own datastore (shuffle-opensearch:3.2.0) is NOT published to host; host 127.0.0.1:9200 is the Wazuh indexer. Shuffle datastore ISM/capacity metrics are NOT queryable from host shell -> consistent with Phase 55 UNVERIFIED OpenSearch monitoring gap.
- EV-10 [VERIFIED]: VERIFIED - Config hashes (read-only): ossec.conf sha256 7a64003555c6ccf157e409cc1b6c2b2d620bad73361563f8493f8f85b44844a8; local_rules.xml 0ac2d51b...; phase18-zeek-rules.xml 7a261130.... (evidence/backup, immutable).

## Backup / Rollback
Config hashes in EV-10 serve as immutable evidence anchors.

## Stop conditions
No index deletion/ISM mutation; retention tooling only.

## Limitations
Shuffle datastore not host-exposed (EV-07).

## Verdict rationale
PARTIAL: Wazuh indexer evidence reachable; Shuffle datastore hash bundle UNVERIFIED from host.
