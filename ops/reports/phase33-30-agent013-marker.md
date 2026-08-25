# Phase 33 Agent 013 Sysmon Marker

Date: 2026-08-24
Status: **BLOCKED - ENDPOINT OFFLINE + OPERATOR RMM PENDING** (C-EP-1).

## Requirement

Authoritative effective Sysmon schema/config dump after apply+restart:
`sysmon -s` dump, `sysmon -c` rc, service/driver state, policy marker/hash (BCA0EB...
4.91 include-oriented), restart persistence, rollback evidence.

## Current state

- Agent 013 **disconnected** at review (last keepalive 19:47Z; offline ~25min; transient
  pattern observed across phases).
- Operator RMM step still pending (no `-s` dump posted to evidence/).
- Supporting volume evidence strong: EID1 62/24h, EID7 39/24h (vs 58.8K/1h pre-tune).

## Unblock

1. 013 online; 2. operator runs apply/check scripts; 3. dump verified -> marker PASS.

## No secrets