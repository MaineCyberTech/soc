# Phase 13 Client Rollout Result (Level.io)

Date: 2026-08-16
Status: **CLIENT DEPLOYED + VERIFIED**

## Client endpoint

| Item | Value |
|---|---|
| Agent ID | 013 |
| Hostname | SAMSUNG |
| OS | Microsoft Windows 11 Pro (10.0.26200) |
| IP | 192.168.111.166 (client network) |
| Status | Active (registered 2026-08-16 04:26 UTC) |
| Group | windows-clients |
| Version | Wazuh v4.14.7 |

## Deployment verification

| Check | Result |
|---|---|
| Agent enrolled + Active | PASS |
| Group assignment | PASS (windows-clients) |
| Event flow | PASS (1004 events/15m: Sysmon 21, System, App, Security) |
| Sysmon collection | PASS (fixed: channel added to shared windows-clients group config 2026-08-16) |
| Alert quality | PASS (0 real threats; 3x SCA CIS summary = informational) |
| FP suppressions | Extended to all Windows agents (event-content scoped, 121105/121106) |

## Level.io variable-driven deployment

- The Level.io automation enrolled the client successfully (name, group,
  manager all correct) - variable model works.

## Fixes applied post-rollout

1. Sysmon channel collection added to windows-clients shared agent.conf
   (client had agent + Windows channels but no Sysmon forwarding).
2. FP suppression rules 121105/121106 de-scoped from agent-012-only to
   event-content scoped (Wazuh rules cannot filter on agent.id) - now protect
   the client too.

## No secrets
