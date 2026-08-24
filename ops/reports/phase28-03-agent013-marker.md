# Phase 28 Agent 013 Sysmon Marker

Date: 2026-08-24
Status: **BLOCKED - ENDPOINT OFFLINE + OPERATOR RMM** (C1).

## Requirement

Authoritative effective Sysmon policy evidence after apply+restart:
`sysmon -s` effective config dump, `sysmon -c` rc, service/driver state, policy hash
(BCA0EB... = 4.91 include-oriented), restart persistence, rollback evidence.

## Current state

- Agent 013 **disconnected** since ~17:28Z (keepalive gap; IP 192.168.111.166) - transient
  endpoint offline; capture cannot run.
- Operator RMM step still pending: `apply-sysmon-tune.ps1` + `sc stop/start Sysmon64` +
  `check-sysmon-tune.ps1` (posts `-s` dump to evidence/).
- Supporting volume evidence: EID1 62/24h, EID7 39/24h (vs 58.8K/1h pre-tune) - tuning
  clearly effective.

## Unblock

1. 013 online; 2. operator runs the no-arg scripts; 3. dump verified -> marker PASS.

## No secrets