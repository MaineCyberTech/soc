# Phase 31 Security and Supply Chain

Date: 2026-08-24

- Images all pinned (8 mutable) + image-gate in CI. checkout@v4 now SHA-pinned.
- Secrets: no commits (scan PASS); stores 0600. Sensor: least-privilege, no payload/PCAP.
- License: Suricata GPL-2.0 (client-safe); no vendor redistribution issue for EVE ingest.
- Dependencies/cache: unchanged from P30 (locks + manifest current).

## No secrets
