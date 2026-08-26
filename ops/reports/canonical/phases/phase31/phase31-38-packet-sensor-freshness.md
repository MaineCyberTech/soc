# Phase 31 Packet Sensor Freshness

Date: 2026-08-24
Status: **DESIGNED** (for Suricata-minimal option, gated on SPAN approval).

- Monitor: last eve.json event mtime (p31-source-freshness), service state (systemd),
  capture drops (stats), Wazuh ingest, memory (cgroup), bounded alert volume.

## No secrets
