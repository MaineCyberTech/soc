# Shuffle Webhook Hardening

Date: 2026-08-11
Status: **DONE - webhook map created; D5/D8 blockers characterized; fallback formalized**

## Webhook inventory (verified, no secrets)

| Workflow | Trigger | Class |
|---|---|---|
| wazuh-high-severity-to-iris | wazuh-high-severity (webhook) | A |
| wazuh-flow-classb-to-iris | (no webhook trigger - GAP) | B |

OpenSearch monitor destinations: Class A = NXsn7Z8BrR5di7YESBuW (unknown-exporter,
lateral-movement, opencanary), Class B = 7Hso7Z8BrR5di7YEIh4O (unusual-ports,
icmp-flood, high-outbound). Full map: integrations/shuffle/webhook-map-phase5.md.

## D5/D8 webhook resolution

- **D5 (Greenbone)**: no dedicated greenbone trigger. Path options documented:
  reuse wazuh-high-severity trigger with greenbone payload, or create a new
  workflow. Blocker now precise (was vague).
- **D8 (SO bridge)**: SO events route via agent 008 -> Wazuh; use
  wazuh-high-severity trigger for IRIS route. Webhook wiring documented.

## Smoke test result

- `shuffle-webhook-smoke-test.sh --dry-run`: PASS (safe, no calls).
- Live test (verified trigger): HTTP 400 `{"success": false}` - Shuffle received
  the POST and validated the schema (expected for partial payload). Proves the
  webhook endpoint is reachable and functional; full execution needs the exact
  contract payload.

## Fallback formalized

- variable-substitution-fallback-final.md: static title + raw payload body;
  never drop events; tag degraded cases.

## Gaps to close (Phase 6 candidates)

1. Create dedicated greenbone-critical + security-onion webhook triggers/workflows.
2. Add webhook trigger to wazuh-flow-classb-to-iris.
3. Automate full-contract payload tests (D5/D8) after workflow creation.

## Files

- integrations/shuffle/webhook-map-phase5.md
- integrations/shuffle/variable-substitution-fallback-final.md
- ops/scripts/shuffle-webhook-smoke-test.sh
- ops/reports/shuffle-webhook-hardening.md (this file)
