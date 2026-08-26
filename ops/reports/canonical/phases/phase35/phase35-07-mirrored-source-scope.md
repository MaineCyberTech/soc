# Phase 35 Approved Mirrored Source Scope

Date: 2026-08-25

## Current SPAN architecture
- Destination: mct-soc-scan ens19 (read-only, AF_PACKET capture)
- Source: unknown (switch SPAN session, not configured by MCT)
- Traffic: VLAN-tagged, mostly UDP broadcast, ~90pps

## Mirrored source identification
- NOT IDENTIFIED - switch SPAN configuration is outside MCT control
- Cannot generate canary traffic from a mirrored source without:
  1. Identifying which switch ports are mirrored
  2. Identifying which hosts are on those ports
  3. Getting approval to generate test traffic from one of those hosts

## Recommendation
- Use Test A (isolated local run) as the packet-layer proof (already proven P34)
- Use Test B (EVE replay) as the downstream proof
- If mirrored source is ever identified, add live canary as Test C

## No secrets
