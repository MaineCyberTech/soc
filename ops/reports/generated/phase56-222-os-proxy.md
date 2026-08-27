# Phase 56: Proxy Map

**Prompt:** 222-os-proxy
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Checked whether any reverse proxy fronts the OpenSearch datastore.

## Evidence
- EV-OS-PRX-1 (VERIFIED): The only nginx in the stack is `shuffle-tls-proxy`, whose published mapping is `192.168.222.149:3443->443/tcp` and which proxies the Shuffle **backend/frontend** TLS interface only. It has no upstream to `shuffle-opensearch:9200`.
- EV-OS-NET-1 (VERIFIED): `shuffle-opensearch` has no host-published port and no proxy reference; it is reached directly on the `mct-security` overlay.

## Backup/Rollback
Read-only; no changes.

## Stop conditions
None. Adding a proxy / TLS termination for OpenSearch is an exposure/TLS gate and was NOT taken.

## Limitations
No proxy currently exists; if a proxy is later introduced for the Shuffle datastore that is an owner-gated exposure change.

## Verdict rationale
No proxy fronts the OpenSearch datastore (the lone nginx proxies Shuffle backend only). DONE.
