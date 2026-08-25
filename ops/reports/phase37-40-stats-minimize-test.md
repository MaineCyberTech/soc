# Phase 37-40: Stats Minimize — Test Plan

**Status:** NOT YET TESTED  
**Date:** 2026-08-25  
**Author:** op-security-lead

## Prerequisites

Requires Suricata configuration change on sensor (agent 016).

## Design

Create a compact stats event containing only 20–30 fields:

- Drop counters (tcp, udp, other)
- Alert counters (total, denied, accepted)
- Packet counters (received, processed, bytes)
- Flow counters (active, new, closed)
- Uptime

## Validation

1. Apply compact stats config to sensor
2. Confirm Suricata emits reduced stats events
3. Run through `wazuh-logtest -a` on manager
4. Verify zero "Too many fields" errors
5. Confirm rule 86601 still matches

## No secrets
