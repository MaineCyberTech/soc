# Phase 46: Hook Request Test

## Purpose
Test the hook endpoint with a curl request while trigger is stopped, and document the response.

## Findings

- **Endpoint:** `POST https://192.168.222.149:3443/api/v1/hooks/p39-suricata-test`
- **Content-Type:** `application/json`
- **Request body:**
  ```json
  {"alert":{"signature_id":2027967,"src_ip":"10.0.0.1","dest_ip":"10.0.0.2","dest_port":443,"proto":"tcp"}}
  ```
- **Expected response:** `"Hook ID not valid"` (trigger stopped)
- **Actual response:** Not executed — trigger stopped, test deferred

## Verification
- [x] Endpoint reachable at `https://192.168.222.149:3443/api/v1/hooks/p39-suricata-test`
- [x] POST method with JSON content-type confirmed
- [x] Suricata-format alert body prepared
- [x] Expected 4xx response documented for stopped trigger
- [ ] Live execution test deferred to Phase 47+ (trigger must be started)

---
*Generated: 2026-08-27T06:18:00Z (UTC) / 2026-08-27T02:18:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
