# Phase 56: Published Port Map

**Prompt:** 220-os-publish
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Inspected the published port map of the Shuffle OpenSearch datastore container to determine host exposure.

## Evidence
- EV-OS-NET-1 (VERIFIED): `docker inspect` of `shuffle-opensearch` (image `opensearchproject/opensearch:3.2.0`) returns `PortBindings {"9200/tcp":null,"9300/tcp":null,"9600/tcp":null,"9650/tcp":null}` — **no host port is published**. OpenSearch is reachable only on the `mct-security` Docker overlay network (`NetworkID e640d29a…`), not via any host published port.
- EV-OS-NET-2 (VERIFIED): From the host shell, `curl http://172.20.0.8:9200/` → HTTP 200 (anonymous). The container IP is reachable via Docker bridge routing but is NOT a published host port.

## Backup/Rollback
Read-only inspection; no changes made. No backup required.

## Stop conditions
None encountered. Altering port publishing is an exposure/TLS gate (per root AGENTS.md) and was NOT taken.

## Limitations
Container IP `172.20.0.8` is assigned by the swarm overlay and is dynamic across service recreation; it must not be hard-coded as a stable monitor endpoint.

## Verdict rationale
The published-port question is fully answered from live container inspection: the Shuffle OpenSearch datastore is **not published to the host** (internal overlay only). DONE.
