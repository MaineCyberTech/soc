# Greenbone Critical Finding -> DFIR-IRIS

Purpose: route critical Greenbone findings into IRIS cases automatically (notify-only).

## Flow

```text
Greenbone alert (severity >= 9.0 or selected CVEs)
  -> webhook POST to Shuffle (greenbone-critical webhook contract)
  -> Shuffle workflow critical-vuln-to-case
  -> IRIS alert -> case (template: critical-vulnerability)
```

## Greenbone side

1. Greenbone -> Alerts -> New:
   - Condition: severity (High/9.0+) or CVSS vector criteria.
   - Method: HTTP GET/POST to `http://<shuffle-host>:3001/api/v1/webhooks/<webhook-id>` with the JSON payload per `integrations/payload-contracts/greenbone-critical.json`.
2. Scope to internet-facing targets first; internal targets can use a higher threshold.

## Payload fields

- asset (IP), severity, cvss, cve, finding, internet_facing (derived in Shuffle from the target list), timestamp.

## IRIS case

- IRIS alert severity 4 for internet-facing critical, 2 for internal.
- Case template `critical-vulnerability` with: CVE, asset, exposure, patch plan, verification.

## Failure modes

| Failure | Handling |
|---|---|
| Greenbone alert webhook fails | Scan report still exported; case created manually from report |
| Shuffle down | Webhook 500; alert remains in Greenbone event log; replay |
| IRIS down | Log to file; retry |

## Acceptance

- A test critical finding (from a test target or injected payload) creates a Class A IRIS case.
