# Phase 21 Zeek Class A Routing Plan

Date: 2026-08-19
Status: **PREPARED - NOT ENABLED** (posture: manual-only until clean 24h window + approval).

## Objective

Auto-route Class A Zeek detections (SSH/SMB/RDP) from Wazuh -> Shuffle -> IRIS once gates clear.

## Prerequisites

1. 24h clean window post-v2.2 (total Zeek < 50; Class A ~0).
2. Operator approval (change control).

## Step 1 - Wazuh

- Rules 122001/122002/122003 level 8, groups `mct,zeek,ssh|smb|rdp`. Verified live.

## Step 2 - Shuffle webhook

- Reuse `wazuh-high-severity-to-iris` pattern:
  - Filter: `rule.groups` contains `mct,zeek` AND level >= 8 AND rule.id in {122001,122002,122003}.
  - Exclude 122004 (admin, lvl 5) and 122006 (UDP, lvl 4) - monitor only.
- Payload: rule.id, rule.level, full_log (ZEEK JSON), agent.name (008), timestamp.

## Step 3 - IRIS

- Case per `integrations/dfir-iris/phase20-zeek-case-template.md`. Correlate ElastiFlow flows.

## Step 4 - Enable with guardrails

- SSH first, 24h capture, revert if > 5 cases/day.

## Rollback

- Remove/disable Shuffle webhook filter; IRIS stops receiving Zeek cases.

## No secrets