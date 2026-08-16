# Critical Alert -> Shuffle (D5 webhook)

## Greenbone alert definition

- Name: MCT-critical-to-shuffle
- Condition: severity >= 9.0 (or selected CVEs)
- Method: HTTP POST
- URL: http://shuffle-frontend/api/v1/hooks/webhook_<trigger-id>
  (wazuh-high-severity trigger 24636c49-a2d0-40c2-887e-ccecdf22fc5c until a
  dedicated greenbone workflow is created)
- Payload: d5-final-test-payload.json fields

## Verification

1. GSA -> Alerts -> Test (or trigger via gvm).
2. Shuffle UI -> Runs: workflow executes.
3. IRIS: alert created (template critical-vulnerability).
4. If variables fail: static title + raw payload fallback.

## Failure handling

- Shuffle down: alert stays in Greenbone; replay after restart.
- IRIS down: log to file; retry.
- Webhook 400: payload schema mismatch - use exact contract fields.
