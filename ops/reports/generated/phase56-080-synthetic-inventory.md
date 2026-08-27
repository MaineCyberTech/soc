# Phase 56: Synthetic IRIS Inventory

**Prompt:** 080-synthetic-inventory
**Report ID:** phase56-080
**Phase:** 56
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Classification:** INTERNAL
**Verdict:** DONE
**Source Path:** /home/user/mct-p56/prompts/080-synthetic-inventory.md

## Summary
Compiled a read-only inventory of known synthetic/test IRIS objects (60, 67, 68) and the
production packet-routing path that created them. All inspection was read-only; no IRIS
objects were created, modified, or deleted.

## Evidence
- **EV-IRIS-060** (VERIFIED): `GET /alerts/60` → HTTP 200. `alert_title`="P53 Packet Routing",
  `alert_tags`="source:suricata,class:A,test:true", `customer_id`=1 (IrisInitialClient),
  `status_id`=2 (New, unassigned), no case/owner/IOC linkage, `alert_source_ref`=2027967,
  `alert_creation_time`=2026-08-27T19:45:05Z.
- **EV-IRIS-067** (VERIFIED): `GET /alerts/67` → 200. Same shape; `alert_creation_time`=
  2026-08-27T22:24:06Z. Carryover ROUTED object (Phase 54 exec `2ce46d4a`).
- **EV-IRIS-068** (VERIFIED): `GET /alerts/68` → 200. Same shape; `alert_creation_time`=
  2026-08-27T23:02:51Z. Carryover ROUTED object (Phase 55 exec `19791f62`).
- **EV-EXEC-001** (VERIFIED): workflow executions list contains carryover execs
  `19791f62-…` (→68) and `2ce46d4a-…` (→67), both `status=FINISHED`, corroborating the
  Phase 54/55 ROUTED carryover evidence.
- **EV-IRIS-CUST-001** (VERIFIED): all three objects reside in production customer 1
  (IrisInitialClient); none are in a dedicated synthetic/test tenant — isolation gap noted.

## Backup / Rollback
Read-only inspection only. No mutation performed; no backup required. The IRIS token at
`data/shuffle/files/iris-shuffle.env` was loaded programmatically for GET auth and never printed.

## Stop conditions
None encountered. Inventory is read-only by design.

## Limitations
- IRIS API exposes object fields; it does NOT expose downstream billing/scorecard/notification/
  client-view/queue accounting logic. Exclusion of these objects from those systems could not be
  proven from IRIS alone (see 085–089).
- OpenSearch datastore (127.0.0.1:9200) unreachable from host (EV-OS-001, UNVERIFIED) so
  Shuffle cache categories (p53_dedup/p53_counters/p53_deadletter/p53_notifications) were not
  directly enumerated.

## Verdict rationale
Inventory fully realized from live read-only IRIS + Shuffle evidence. All three synthetic/test
objects confirmed present, tagged `test:true`, and located in production customer 1.
