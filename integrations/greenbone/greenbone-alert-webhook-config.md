# Greenbone Alert Webhook Configuration

Purpose: Greenbone -> Shuffle -> IRIS critical finding routing.

## Shuffle side (verify/create)

1. Shuffle UI -> Workflows: confirm `greenbone-critical-to-case` exists, or
   create it: webhook trigger (label `greenbone-critical`) -> Shuffle Tools log
   -> HTTP action "Create DFIR-IRIS alert" (https://iriswebapp_nginx:8443/alerts/add,
   Bearer IRIS API key) with notify-only semantics.
2. Copy the webhook trigger ID from the workflow.
3. Webhook URL: `http://shuffle-frontend/api/v1/hooks/webhook_<trigger_id>`
   (from the Wazuh host network; use 127.0.0.1:3001 if on host).

## Greenbone side (VM103 - operator action)

Via gvm-cli or Greenbone UI on mct-soc-scan (192.168.222.154):

1. Configuration -> Alerts -> New alert.
2. Condition: severity High (>= 9.0) or CVSS >= 9.0.
3. Method: HTTP GET or POST to the Shuffle webhook URL above.
4. Payload: integrations/greenbone/d5-final-test-payload.json fields
   (asset, severity, cvss, cve, finding, internet_facing, timestamp).
5. Attach alert to the monthly recurring scan task.

## IRIS side

- Case template: critical-vulnerability (11 fields).
- Class A if internet_facing=true, B otherwise (decided in workflow or analyst).

## Validation

1. POST d5-final-test-payload.json to the webhook URL.
2. Confirm Shuffle UI -> Runs shows FINISHED.
3. Confirm IRIS alert/case created.
4. Confirm no automated remediation fired (notify-only).

## Failure modes

| Failure | Handling |
|---|---|
| Webhook 400 | payload shape mismatch - use exact contract fields |
| Shuffle down | alert stays in Greenbone event log; replay after restart |
| IRIS down | log to file; retry |
| Variable substitution broken | use static title + raw payload (fallback pattern) |
