# Phase 55: SID 2027967 Baseline

**Prompt:** 220-sid-baseline
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** DONE

## Summary
SID 2027967 baseline captured from live Shuffle execution history. Of 100 recent executions of `suricata-packet-routing`, 87 carry `signature_id:2027967`, establishing real volume/context for the packet-routing lane. ROUTED success (EV-ROUTE-01) confirms the baseline path is healthy end-to-end.

## Evidence
- EV-SID-01 (VERIFIED): Shuffle API `/workflows/e133a645-95b9-4e01-9454-e270d2a0b599/executions?limit=200` returned 100 executions; 87 reference SID 2027967; 90 returned `success:true`; 0 malformed-control escapes observed.
- EV-ROUTE-01 (VERIFIED): execution `2ce46d4a-b071-4331-b175-b40ee2b31692` → `state: ROUTED`, `http_status: 200`, `destination_object_id: 67` (IRIS severity Critical, status New). Re-proves Phase 54 ROUTED via the service-scoped secret, not a code secret.
- EV-SECRET-01 (VERIFIED): `docker secret ls` → `iris-shuffle-env` (ID `4vpfvc92ice01x52qtc69yi2c`, mode 0444); `docker service inspect shuffle-tools_1-2-0` shows the secret mounted as `iris-shuffle.env` (mode 292/0444), service-scoped only. No token value read or printed.
- EV-TRIG-01 (VERIFIED): `/triggers` → webhook `736b7410-ed6a-52af-b369-89dbef6386cb` (`suricata-eve-in`) `running: true`; org `264c0502-9136-4cfc-938b-390b97b861b8`.
- EV-FAIL-01 (VERIFIED): failure categories across the 100 executions — AUTH_FAILED 11, Exception 10, DATASTORE_READ_FAIL 4, UNKNOWN 4, COUNTER_FAIL 3, TARGET_FAILED 1 (counts from result text).
- EV-DL-01 (PARTIAL): `p53_deadletter` / `p53_notifications` wiring carried from Phase 53; 0 occurrences in the inspected 100-execution window (no failure fired them); content not independently re-read (read-only, no token).
- EV-OS-01 (UNVERIFIED): OpenSearch/Wazuh indexer not reachable on 127.0.0.1:9200 from host (connection closed / TLS verify); health status not re-read this run (carryover: yellow/single-node, Phase 52/53).
- EV-IRIS-01 (PARTIAL): IRIS lane functional via EV-ROUTE-01 (object 67); direct IRIS object-count/capacity not read (token file not read/printed; internal network).

## Backup / Rollback
Read-only. No change made; nothing to roll back. Service-scoped secret (EV-SECRET-01) and ROUTED state are the durable baseline anchors.

## Stop conditions
None encountered (read-only).

## Limitations
EV-OS-01 UNVERIFIED (indexer not reached from host). Window = most-recent 100 executions, not full history.

## Verdict rationale
DONE: real execution data establishes SID 2027967 volume (87/100) and a verified ROUTED baseline (http 200, IRIS object 67).
