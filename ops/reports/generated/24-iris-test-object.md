# Phase 46: IRIS Test Object

## Purpose
Plan for creating a test IRIS alert to verify end-to-end integration.

## Findings

### IRIS Alert Endpoint
- **URL:** `https://127.0.0.1:8443/alerts/add` (or `iriswebapp_nginx:8443`)
- **Method:** POST
- **Content-Type:** application/json
- **Auth:** Real Bearer token required

### Standard IRIS Alert Format
```json
{
  "alert_title": "Test Alert - MCT Integration",
  "alert_source": "MCT Security Stack",
  "alert_source_ref": "mct-test-001",
  "alert_severity": "Medium",
  "alert_status": "New",
  "alert_description": "Automated test alert for IRIS integration verification"
}
```

### Expected Response
- HTTP 200 or 201 with alert ID in response body
- Alert visible in IRIS UI under alerts

### Test Workflow
1. Generate real IRIS Bearer token from IRIS UI
2. POST test alert to `/alerts/add`
3. Verify response code and alert ID
4. Confirm alert appears in IRIS UI
5. Clean up test alert

## Verification
- [ ] IRIS alert endpoint reachable at `https://127.0.0.1:8443/alerts/add`
- [ ] Real Bearer token obtained
- [ ] Test alert POST succeeds (200/201)
- [ ] Alert visible in IRIS UI
- [ ] Test alert cleaned up

---
*Generated: 2026-08-27T06:24:00Z (UTC) / 2026-08-27T02:24:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
