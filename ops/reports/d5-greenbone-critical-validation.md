# Drill D5: Greenbone Critical Finding Validation

Date: 2026-08-11
Status: **PARTIAL - route validated; end-to-end webhook test pending Shuffle webhook ID**

## Path

```text
Greenbone >= 9.0 finding
  -> Greenbone alert webhook (HTTP POST to Shuffle webhook)
  -> Shuffle workflow critical-vuln-to-case
  -> IRIS case (template: critical-vulnerability, Class A if internet-facing)
  -> reporting
```

## Validated components

| Component | Status | Evidence |
|---|---|---|
| Greenbone scan capability | OK | Phase 2 test scan completed (MCT-Wazuh-host-149, Discovery config) |
| Shuffle backend | OK | /api/v1/health: success, workflows run_finished |
| Shuffle workflow critical-vuln-to-case | EXISTS | integrations/shuffle/workflows/critical-vuln-to-case.md |
| IRIS case template | EXISTS | integrations/dfir-iris/case-templates/critical-vulnerability.md |
| Payload contract | EXISTS | integrations/shuffle/webhook-contracts/greenbone-critical.json |
| Notify-only mode | CONFIRMED | no automated remediation; manual approval for containment |
| Webhook config on Greenbone side | NOT VERIFIED | requires gvm-cli/UI on mct-soc-scan VM |

## Test payload

Synthetic critical finding (RFC-safe, no real scan):

```json
{
  "asset": "192.168.222.149",
  "severity": "critical",
  "cvss": 9.8,
  "cve": "CVE-2026-0000",
  "finding": "Phase 4 drill D5 synthetic critical finding",
  "internet_facing": false,
  "timestamp": "2026-08-11T00:00:00Z"
}
```

## Blockers

1. **Shuffle webhook ID unknown** to this session - the specific webhook URL
   (created in Shuffle UI per phase 2 wiring doc) is needed to POST the test
   payload and observe the workflow run. Operator action: run the payload
   through the Shuffle webhook and confirm IRIS case creation.
2. **Greenbone alert config** (webhook to Shuffle) not yet created in gvm -
   documented in critical-finding-escalation-runbook.md; requires VM access.

## Files

- integrations/greenbone/d5-critical-test-payload.json
- integrations/greenbone/critical-finding-escalation-runbook.md
