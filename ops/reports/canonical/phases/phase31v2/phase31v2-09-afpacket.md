# Phase 31v2 AF_PACKET Tuning

Date: 2026-08-24
- Suricata build supports AF_PACKET + PACKET_FANOUT (build-info).
- Config: af-packet ens19, cluster-type cluster_flow, ring-size 250, buffer-size 24KiB,
  max-pending-packets 1024, tpacket-v3 (falls back to v2 in autofp - noted).
- Measured: 16,523 pkts / 0 drops at ~90pps; runmode autofp 1 RX thread.

## No secrets
