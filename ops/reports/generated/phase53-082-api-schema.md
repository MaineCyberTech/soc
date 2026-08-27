# Phase 53: IRIS Object Schema

**Prompt:** 082-api-schema
**Generated (UTC):** 2026-08-27T20:08:15Z
**Operator (EDT):** 2026-08-27T16:08:15-0400
**Verdict:** DONE

## Summary
Documented the IRIS alert object request/response schema and object-ID field as observed from the authoritative live ROUTED proof. The workflow POSTs to IRIS and receives a 200 with a JSON body whose `data` carries the created object identity; the Shuffle result maps it to `destination_object_id`.

## Evidence
- E5: live ROUTED execution `4d5b9d15-...` result -> `state=ROUTED, http_status=200, destination_object_id=60`, raw response `{"status":"success","message":"","data":{...}}` with `severity` (severity_id 6 / Critical) and `status` (status_id 2 / New) blocks.
- E6: workflow `e133a645` (suricata-packet-routing) define uses `execute_python` (Shuffle Tools) to call IRIS; token sourced from `/shuffle-files/iris-shuffle.env` (IRIS_API_KEY), never embedded.

## Backup / Rollback
N/A.

## Stop conditions
None.

## Limitations
The full IRIS OpenAPI spec was not independently fetched (would require secret-bearing call). Schema fields are taken from the live response body captured in the execution result, which is sufficient to confirm the object-ID field (`destination_object_id`=60) and 200-class response.

## Verdict rationale
Object schema and object-ID field confirmed from real ROUTED response.
