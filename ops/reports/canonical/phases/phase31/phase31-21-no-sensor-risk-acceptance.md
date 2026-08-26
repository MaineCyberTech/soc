# Phase 31 No-Sensor Risk Acceptance

Date: 2026-08-24
Status: **NOT REQUIRED for the decision** (Suricata-minimal passed the sub-2GiB lab benchmark).

## Note

- A no-sensor outcome is the fallback ONLY if no candidate passes. Suricata-minimal measured
  31MB/0-drops (16), so packet monitoring is not disabled outright.
- **Residual gap (documented)**: production-grade traffic volume on the client LAN
  (192.168.111.0/24) is UNPROVEN until an approved SPAN mirror provides a full-volume
  benchmark. Until then, detection on raw packet inspection is limited to the lab profile +
  compensating NetFlow/endpoint telemetry. This is the acceptance-gated element of 22/23.

## No secrets