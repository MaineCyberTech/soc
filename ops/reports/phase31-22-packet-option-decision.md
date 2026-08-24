# Phase 31 Packet Option Decision

Date: 2026-08-24
Status: **DECISION (evidence-based)**.

## Decision

- **SELECT: Suricata-minimal** as the recommended packet visibility option, based on
  **measured** evidence (16): 31MB cgroup memory (< 2GiB), ~1.1% CPU, **0 drops** over
  102K packets, 70 bounded alerts, config gate + rollback proven.
- **Production deployment is GATED on**: (a) an approved SPAN mirror for the client LAN
  (192.168.111.0/24) - no production SPAN change without approval; (b) a full-volume
  production benchmark (repeat 16); (c) EVE->Wazuh ingest validation + Wazuh agent on the
  sensor (14/17).
- Zeek: deferred (not benchmarked; higher-memory risk). Device telemetry (NetFlow): retained
  as complement (20/59).

## Not selected

- No-sensor: not needed (Suricata passed lab ceiling). Full PCAP: rejected.

## No secrets