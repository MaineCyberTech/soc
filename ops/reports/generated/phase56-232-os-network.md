# Phase 56: Network Policy

**Prompt:** 232-os-network
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Verdict:** DONE

## Summary
Documented expected reachability / network policy for the Shuffle OpenSearch datastore.

## Evidence
- EV-OS-NET-1 (VERIFIED): `shuffle-opensearch` attaches only to the `mct-security` overlay (`NetworkID e640d29a…`, IP `172.20.0.8`); not host-published (see 220).
- EV-OS-NET-2 (VERIFIED): Expected in-network clients (Shuffle backend/orborus/workers on the same overlay) reach `shuffle-opensearch:9200`. Host can reach `172.20.0.8:9200` via Docker bridge routing but the IP is dynamic.
- EV-OS-NET-3 (VERIFIED, SEPARATE): `127.0.0.1:9200` is the Wazuh indexer (different network/cluster); it is the incorrect target for Shuffle-datastore monitoring.
- EV-OS-PRX-1 (VERIFIED): No proxy fronts OpenSearch (see 222).

## Backup/Rollback
Read-only; no changes.

## Stop conditions
None. Adding firewall rules / published exposure is a gate and was NOT taken.

## Limitations
No host firewall rule was inspected beyond port-binding evidence; reachability stated from observed bindings + live curl.

## Verdict rationale
Network policy / expected reachability mapped: overlay-only, host reachable via dynamic container IP, loopback is a different cluster. DONE.
