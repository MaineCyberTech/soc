# Phase 35 Canary Method Decision

Date: 2026-08-25

## Methods evaluated

| Method | Proves | Does not prove | Feasibility |
|---|---|---|---|
| Mirrored-source packet canary | Full live packet path (capture -> detect -> forward -> decode) | Downstream routing (Shuffle) | Requires approved source host in SPAN scope |
| Isolated packet-path canary | Detection engine works (local suricata run) | Live capture, agent forwarding | Proven P34 (local pcap) |
| Marked downstream EVE replay | Wazuh decode, Shuffle routing, dedup, counter | Packet capture, live detection | Feasible now (synthetic injection) |
| Combined two-test model | Both packet + downstream proof | Nothing missing | Recommended |

## Decision: COMBINED TWO-TEST MODEL

1. **Test A - Packet canary**: From approved mirrored source (when identified) OR from isolated local run (already proven P34)
2. **Test B - EVE replay**: Marked synthetic EVE record injected into agent 016 -> Wazuh -> test group (proves downstream pipeline)

## What each proves
- Test A: Suricata detection engine fires SID 2027967 correctly
- Test B: Agent 016 forwards, Wazuh decodes, test-group delivery works

## What is NOT claimed
- Live SPAN capture of real traffic (blocked by read-only SPAN)
- Production routing (deferred)

## No secrets
