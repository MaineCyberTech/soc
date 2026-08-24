# Phase 31 Detection Quality

Date: 2026-08-24

- Endpoint: EID7 39/0 per 24h (013/014) - bounded; markers pending.
- Packet: Suricata-minimal 70 alerts/~102K pkts (focused rules); FPs low; routing 0 real
  Class A. Suricata alerts -> Wazuh ingest designed (production gated on SPAN).
- Coverage gaps: raw-packet IDS limited to lab profile until SPAN; compensating NetFlow +
  endpoint. No duplicate-alert or case-quality issue observed.

## No secrets
