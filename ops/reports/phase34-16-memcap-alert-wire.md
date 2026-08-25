# Phase 34 Memcap and Emergency Alert Wiring

Date: 2026-08-25

## Implementation
- Source: Suricata eve.json stats -> flow.memcap, tcp.ssn_memcap_drop, tcp.segment_memcap_drop
- Check: alert on any memcap hit > 0 or emerg_mode_entered > 0
- Threshold: any occurrence (memcap = critical)
- Evidence: flow.memcap=0, ssn_memcap_drop=0, segment_memcap_drop=0, emerg_mode_entered=0

## Current state
- Flow memcap: 0 (all clear)
- TCP memcap: 0 (all clear)
- Emergency mode: 0 (all clear)
- Flow spare: 9,533 (healthy, not exhausted)

## Runbook
- Increase flow.memcap or stream.memcap if persistent
- Investigate traffic volume surge

## No secrets
