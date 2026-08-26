# Phase 18 Syslog Client Subnet and TCP/UDP Alignment

Date: 2026-08-17

## Status: ALIGNED

## Client subnet decision

- 192.168.111.0/24 ADDED to 15140 allowlist (operator-approved).
- Client devices (UniFi 100.64.1.107 etc.) can now send syslog directly.

## TCP/UDP posture

| Protocol | Docker map | Remoted | Status |
|---|---|---|---|
| UDP 15140 | YES | syslog listener | ACTIVE |
| TCP 15140 | YES | NO TCP listener | DOCUMENTED UNUSED |

- Recommendation: keep TCP mapped (future TCP-syslog senders) but document
  as unused; or remove mapping. No change this phase (non-breaking).

## Stale 514 references

- Verified: no listener on 514; docs mark retired; no live references.

## No secrets
