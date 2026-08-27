# Phase 56: Listener Map

**Prompt:** 221-os-listener
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Mapped what listens for the OpenSearch datastore at container vs host scope.

## Evidence
- EV-OS-NET-1 (VERIFIED): `shuffle-opensearch` declares internal listeners `9200/tcp` (REST), `9300/tcp` (transport), `9600/tcp` (performance analyzer), `9650/tcp` (PCPI) — none host-published (see 220).
- EV-OS-NET-3 (VERIFIED, SEPARATE — Wazuh cluster): On the host loopback, `127.0.0.1:9200` is bound by the **Wazuh indexer** (`multi-node-wazuh1.indexer-1`), NOT the Shuffle OpenSearch. `curl http://127.0.0.1:9200/` → HTTP 000 "Empty reply from server"; `https://127.0.0.1:9200/` → HTTP 401 (auth required). This is a distinct cluster and must be kept separate from Shuffle OpenSearch evidence.
- EV-OS-NET-2 (VERIFIED): Host can reach the Shuffle OS only via its overlay IP `172.20.0.8:9200`.

## Backup/Rollback
Read-only; no changes.

## Stop conditions
None. No listener change attempted (exposure gate).

## Limitations
Host loopback `127.0.0.1:9200` resolves to the Wazuh indexer, which is the root of the Phase 55 "monitoring gap" — a host monitor pointed there never reaches the Shuffle datastore.

## Verdict rationale
Listener map established: Shuffle OS listens only on the overlay network; host `127.0.0.1:9200` is the unrelated Wazuh indexer. DONE.
