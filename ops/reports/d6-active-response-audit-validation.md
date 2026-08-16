# Drill D6: Active Response Audit Validation

Date: 2026-08-11
Status: **PASS**

## Current active response

- Command: `firewall-drop` (Wazuh standard AR)
- Triggered by: rule 5710 (sshd invalid user / auth failures), 600s block
- Agents: deployed on enrolled agents (docker-host, mct-portal-dev, securityonion)

## Evidence

- **2,518 active-response events in last 7 days** (rules 651 "Host Blocked by
  firewall-drop Active Response" and 652).
- Top rules: 651 (1,510), 652 (1,008).
- Top agent: mct-portal-dev (blocking SSH brute force sources).
- Audit workflow: `ops/scripts/active-response-audit.sh` produces
  `reporting/output/active-response-weekly.md`.

## Fix applied during drill

- The audit script queried group `active-response` but Wazuh uses
  `active_response` - the query returned 0. Fixed to query both group names;
  now reports 2,518 events correctly.

## Mock/synthetic audit record

Real events exist (2,518) - no synthetic mock needed. A safe synthetic payload
is provided for replay in integrations/test-events/d6-active-response-mock.json.

## IRIS/report path

- AR events are Class B (per classification matrix) - weekly report suffices;
  no auto-IRIS case. Repeated AR loop would escalate via rule analysis.
- Manual IRIS case creation path documented in routing map if AR fires repeatedly.

## Safety

- No real brute force was performed (per prompt). Validation used existing
  archive data + audit query.
- firewall-drop AR blocks are temporary (600s) and reversible.

## Files

- integrations/wazuh/active-response-audit-workflow.md
- integrations/test-events/d6-active-response-mock.json
