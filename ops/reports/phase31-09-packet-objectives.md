# Phase 31 Packet Visibility Objectives

Date: 2026-08-24

## Objectives / constraints

- Monitored traffic: the client/LAN where a sensor can capture (currently: isolated lab
  benchmark on mct-soc-scan; production = client LAN 192.168.111.0/24 subject to an
  approved SPAN mirror - no production SPAN change without approval).
- **Hard ceiling: < 2 GiB measured working set/cgroup memory** under the test profile.
- Retained event types: **IDS alerts only** + minimal metadata (src/dst/port/rule/severity).
- Disabled by default: full PCAP, file extraction, broad protocol logging, payload logging,
  all-event archival.
- Thresholds: packet loss ~0 (no sustained drops), CPU < 50% avg, queue stable, no routing
  flood, memory < 2GiB.
- Privacy: no payload capture; minimal metadata. Storage: bounded EVE rotation (~1.3MB/100K
  packets). RPO: log rotation/collection aligned to Wazuh agent.

## Acceptance

- PASS requires: measured memory < 2GiB, 0 sustained drops, detection quality verified,
  rollback proven, EVE->Wazuh ingest bounded.

## No secrets