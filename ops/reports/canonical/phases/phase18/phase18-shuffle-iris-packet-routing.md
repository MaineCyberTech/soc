# Phase 18 Shuffle/IRIS Packet Routing

Date: 2026-08-17

## Status: ROUTING DISABLED (noise validation first)

## Class assignment (proposed)

| Class | Zeek rules | Suricata | Action |
|---|---|---|---|
| A | 122001 SSH (8), 122002 SMB (8), 122003 RDP (8) | severity 1-2 alerts | IRIS case (when validated) |
| B | 122004 admin ports (5), 122006 UDP (4) | severity 3 | review queue |
| C | 122000 base (3), 122005 subnet (3) | severity 4+ | monitor only |

## Gate

- NO IRIS routing until 24h noise check passes (P18.04).
- Routing map created; workflow changes deferred.

## Files

- integrations/shuffle/phase18-zeek-suricata-routing-map.md (created)
- integrations/dfir-iris/phase18-packet-case-template.md (created)

## No secrets
