# Phase 56: OpenSearch Access Certificate

**Prompt:** 240-os-cert
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** PARTIAL

## Summary
Read-only inspection of OpenSearch access/cert posture. Wazuh indexer is cert-reachable on 127.0.0.1:9200 (auth required, succeeded). Shuffle's own datastore (shuffle-opensearch) is not published to the host, so TLS/cert access to Shuffle datastore metrics from the host is not verifiable.

## Evidence
- EV-06 [VERIFIED]: VERIFIED - Wazuh indexer 127.0.0.1:9200 reachable (HTTP 401 auth-required); cluster_name=wazuh-cluster, ES-compat 7.10.2; indexer admin auth via WAZUH_ADMIN_PASSWORD (path /opt/wazuh-docker/multi-node/ops/creds.env) succeeds.
- EV-07 [VERIFIED]: VERIFIED - Shuffle's own datastore (shuffle-opensearch:3.2.0) is NOT published to host; host 127.0.0.1:9200 is the Wazuh indexer. Shuffle datastore ISM/capacity metrics are NOT queryable from host shell -> consistent with Phase 55 UNVERIFIED OpenSearch monitoring gap.
- EV-08 [UNVERIFIED]: UNVERIFIED - Wazuh manager API (:55000) authentication with WAZUH_ADMIN_PASSWORD returned 401 (invalid creds for API admin user); cluster health via API not obtainable. Limitation, not a defect.

## Backup / Rollback
None required (read-only). Config hashes captured in EV-10 for any future restore.

## Stop conditions
No mutation; OpenSearch datastore disk/ISM changes remain approval-gated (per AGENTS.md).

## Limitations
EV-07: Shuffle datastore not host-reachable -> cert/ISM metrics UNVERIFIED. EV-08: Wazuh API admin auth inconclusive.

## Verdict rationale
PARTIAL: Wazuh indexer cert access VERIFIED; Shuffle datastore cert/monitoring UNVERIFIED due to no host publication.
