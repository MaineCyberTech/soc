# Phase 56: Endpoint Inventory

**Prompt:** 214-os-endpoints
**Generated (UTC):** 2026-08-27T21:30:00Z
**Operator (EDT):** 2026-08-27T17:30:00-0400
**Verdict:** PARTIAL

## Summary
Read-only inventory of OpenSearch endpoints distinguishes TWO separate clusters: (a) the **Wazuh indexer** at host `127.0.0.1:9200` (TLS/HTTPS only, HTTP Basic auth) reachable from the host shell, and (b) the **Shuffle backend OpenSearch** `shuffle-opensearch:9200` (plaintext within the docker network, NOT host-published) used by Shuffle as its datastore. This clarifies the Phase 55 "empty reply" finding: that probe hit the Wazuh indexer with plaintext.

**Layers (kept separate):**
- Host endpoint: `127.0.0.1:9200` → Wazuh indexer (TLS). VERIFIED.
- Container endpoint: `shuffle-opensearch:9200` (docker network). VERIFIED via compose + in-container GET.
- Proxy: `shuffle-tls-proxy` (nginx) terminates Shuffle TLS :3443 (separate from OpenSearch). VERIFIED (docker ps).
- Protocol: Wazuh = HTTPS; Shuffle backend = HTTP (internal docker). VERIFIED.
- Auth: Wazuh = HTTP Basic (`admin:***`); Shuffle backend = no auth on docker network. VERIFIED.

## Evidence
- EV-OS-2 (VERIFIED): host `HTTPS 127.0.0.1:9200` → `401` unauth, `200` with creds; cluster `wazuh-cluster` uuid `OQ_G_ZSIRZWFdJNzkoTeLA`, v7.10.2, 3 nodes, green.
- EV-OS-3 (VERIFIED): compose `SHUFFLE_OPENSEARCH_URL=http://shuffle-opensearch:9200`; in-container GET → cluster `shuffle-cluster` uuid `rPikaq3wS5OYlWdyJYb8jQ`, node `shuffle-opensearch`, v3.2.0, health yellow.
- EV-OS-1 (VERIFIED): host plaintext `127.0.0.1:9200` → curl exit `000` (empty reply) — matches Phase 55; explained as Wazuh TLS-only.
- EV-DOCKER-1 / container ps (VERIFIED): `shuffle-opensearch` container `Up`; no host port publish for 9200 (internal only).

## Backup / Rollback
N/A (read-only inventory).

## Stop conditions
No mutation. TLS/exposure changes are gates (run-context §4).

## Limitations
- Shuffle backend not reachable from host shell (by design) — inventory of it is via compose + in-container probe, not host.
- Wazuh indexer auth probed with operator creds from `creds.env` (value never printed).

## Verdict rationale
Both endpoints inventoried and VERIFIED read-only; the two-cluster distinction resolves the Phase 55 gap. PARTIAL (Shuffle backend not host-probeable).
