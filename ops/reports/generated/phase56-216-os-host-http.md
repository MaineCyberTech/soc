# Phase 56: Host HTTP Probe

**Prompt:** 216-os-host-http
**Generated (UTC):** 2026-08-27T21:30:00Z
**Operator (EDT):** 2026-08-27T17:30:00-0400
**Verdict:** PARTIAL

## Summary
Read-only host HTTP probe of `127.0.0.1:9200` (plaintext). Result: connection yields no HTTP response (curl exit `000`, empty body) — matching the Phase 55 "Empty reply from server" finding. Root cause: the host `:9200` is the **Wazuh indexer**, which is TLS-only; plaintext HTTP is not served. This refines (not contradicts) Phase 55.

## Evidence
- EV-OS-1 (VERIFIED): `curl -m5 http://127.0.0.1:9200/` → `exit=000`, 0 body bytes (empty reply). No response headers.
- EV-OS-2 (VERIFIED): same host over HTTPS → `401` (auth required), `200` with creds → confirms a TLS-only OpenSearch (Wazuh indexer) is what answers `:9200`.
- EV-OS-3 (VERIFIED): Shuffle backend OpenSearch is NOT on host `:9200` (it is `shuffle-opensearch:9200`, docker-internal) — so the plaintext "empty reply" was never the Shuffle datastore.

## Backup / Rollback
N/A (read-only probe).

## Stop conditions
No mutation. Enabling plaintext HTTP on the Wazuh indexer or changing exposure is a TLS/exposure gate (run-context §4).

## Limitations
- Probe hit the Wazuh indexer, not the Shuffle backend (which is unreachable from host). If the prompt intended the Shuffle backend, that endpoint is not host-published (see 214/218).
- No response headers captured (connection did not complete).

## Verdict rationale
Host HTTP probe result VERIFIED (empty reply / exit 000) and root-caused read-only. PARTIAL because the targeted backend (Shuffle) is not host-reachable.
