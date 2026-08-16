# D5 Greenbone Critical - Final Status

Date: 2026-08-11
Status: **COMPONENT-PASS (unchanged) - last hop: Greenbone alert config on VM103**

## Verified components (cumulative)

- Shuffle webhook reachable (HTTP 400 = schema validation; endpoint functional)
- Shuffle workflows + triggers mapped (webhook-map-phase5.md)
- IRIS template critical-vulnerability exists (11 fields)
- Test payload ready (d5-final-test-payload.json)
- Greenbone gvmd healthy; admin credential present (GREENBONE_ADMIN_PASSWORD)
- Notify-only mode preserved

## Remaining (precise blocker)

- Greenbone alert object (severity >= 9.0 -> HTTP POST to Shuffle webhook)
  not yet created - requires GSA UI or gvm-cli on VM103 (operator action;
  GMP CLI not installed - path documented).

## Completion steps (operator)

1. GSA login (admin / GREENBONE_ADMIN_PASSWORD from .env).
2. Configuration -> Alerts -> New: severity High, method HTTP POST,
   URL = Shuffle webhook (wazuh-high-severity trigger).
3. Attach alert to the MCT-core-infra-monthly task.
4. Test with d5-final-test-payload.json -> confirm IRIS alert.
