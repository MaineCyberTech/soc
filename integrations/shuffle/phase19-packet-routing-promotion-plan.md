# Phase 19 Packet Routing Promotion Plan

Date: 2026-08-18
Status: **PREPARED - NOT ENABLED** (decision: NO-ROUTE, see phase19-packet-routing-decision.md).

## Objective

Route Class A packet detections (Zeek SSH/SMB/RDP, later Suricata sev 1-2) from Wazuh to
Shuffle to DFIR-IRIS once noise gates clear.

## Prerequisites (all must be true)

1. Zeek v2 deployed + 24h re-measure: total Zeek alerts < 2K/24h; Class A (122001-122003) still 0 or low.
2. Suricata ingest validated + 7d volume measured (separate gate).
3. Operator approval via change control.
4. Full routing map from P18 (`integrations/shuffle/phase18-zeek-suricata-routing-map.md`) reviewed.

## Step 1 - Wazuh side

- Confirm rules fire with correct groups/levels:
  - 122001/122002/122003 level 8, groups `mct,zeek,ssh|smb|rdp`.
  - Suricata 122011 (sev2) level 8, 122012 (sev1) level 10, groups `mct,suricata,high|critical`.

## Step 2 - Shuffle webhook

- Reuse `wazuh-high-severity-to-iris` webhook pattern:
  - Filter: `rule.groups` contains `mct,zeek` AND rule level >= 8 (Class A only), OR
    `rule.groups` contains `mct,suricata` AND level >= 8.
  - Exclude 122004 (admin ports, Class B) and 122006 (UDP, Class B) explicitly to keep noise out.
- Payload: rule.id, rule.level, full_log (ZEEK JSON / eve JSON), agent.name (008/015), timestamp.

## Step 3 - IRIS

- Create case using `integrations/dfir-iris/phase19-packet-case-template.md`.
- Correlate ElastiFlow flows for the src/dst pair over the prior 4h.

## Step 4 - Enable with guardrails

- Enable one rule family at a time (SSH first), 24h noise capture, revert if > 5 cases/day.
- Class B (122004/122006, Suricata sev 3) stay monitor-only.

## Rollback

- Remove/disable the Shuffle webhook filter; IRIS stops receiving packet cases. Wazuh alerting
  remains unaffected.

## Owner / approval

- Owner: SOC operator. Approval: change-control entry before any enable step.

## No secrets