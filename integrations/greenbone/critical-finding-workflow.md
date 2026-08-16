# Greenbone Critical Finding Workflow

## Objective

Route critical findings (severity >= 9.0 or selected CVEs) to IRIS in
**notify/manual mode** - no automated remediation.

## Flow

```text
Greenbone alert (severity >= 9.0, internet-facing asset)
  -> webhook POST to Shuffle (greenbone-critical contract)
  -> Shuffle workflow critical-vuln-to-case
  -> IRIS case (template: critical-vulnerability) - NOTIFY ONLY
```

## Greenbone alert config

- Condition: severity High (9.0+) or CVSS vector criteria.
- Method: HTTP POST to `http://<shuffle-host>:3001/api/v1/webhooks/<webhook-id>` with JSON payload per `integrations/payload-contracts/greenbone-critical.json`.
- Scope: internet-facing targets first; internal targets use higher threshold (10.0 or CVE selection).

## IRIS side

- Case template: `critical-vulnerability` (integrations/dfir-iris/case-templates/).
- Class A if internet-facing with known exploit; Class B otherwise.
- Analyst triage: CVE, exposure, exploit availability, asset owner.

## Safety

- **Notify only.** No automated patch, quarantine, or firewall change.
- If Shuffle is degraded: manual case creation from the alert (see routing map); keep the raw Greenbone payload in the case.
- Containment actions always require operator approval.

## Verification

- After any Greenbone config change: generate a test alert from gvm-cli and confirm the webhook -> Shuffle -> IRIS path (Phase 05 drill D5).
