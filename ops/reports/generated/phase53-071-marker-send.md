# Phase 53: Send Marker

**Prompt:** 071-marker-send
**Generated (UTC):** 2026-08-27T20:08:35Z
**Operator (EDT):** 2026-08-27T16:08:35-0400
**Verdict:** DONE

## Summary
Posted the unique synthetic marker through the suricata-eve-in packet hook (the single permitted live-test packet for this batch). The hook accepted it (200) and produced a webhook-sourced execution. State was MALFORMED (synthetic schema), so no IRIS alert was created — the safer outcome.

## Evidence
- E1: POST https://192.168.222.149:3443/api/v1/hooks/webhook_736b7410-ed6a-52af-b369-89dbef6386cb with the 313-byte marker (sid 2027967) -> http_code=200.
- E2: resulting execution 254d6c05, execution_source=webhook, execution_org=264c0502-9136-4cfc-938b-390b97b861b8, status=FINISHED.
- E3: workflow result state=MALFORMED (sid=null) — synthetic event schema not matched by the suricata parser; NO IRIS alert/destination_object_id created.
- E4: authoritative ROUTED proof remains execution 4d5b9d15 (state=ROUTED, http 200, destination_object_id=60).

## Backup / Rollback
N/A. No production mutation; the MALFORMED state created no IRIS object.

## Stop conditions
None.

## Limitations
Only one packet permitted per batch; the marker used a surrogate schema that the routing workflow classifies MALFORMED, so this is proof of *ingestion*, not of *routing*. ROUTED is proven separately by execution 4d5b9d15.

## Verdict rationale
Marker posted through the packet hook (200) and produced a webhook-sourced execution. DONE (send proven; routing proven by the LIVE ROUTED PROOF).
