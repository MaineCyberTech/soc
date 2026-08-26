# Phase 11 Architecture Update

Date: 2026-08-16

## Deliverables

- ARCHITECTURE.md (top-level source of truth)
- PORTS.md (top-level port registry)
- REPO-MAP.md (structure map)
- integrations/integration-matrix.md (updated P9/P10 - current)

## Architecture state

- Remote syslog: **15140** (514 retired) - documented.
- Security Onion: packet-ingestion feeding Wazuh via agent 008 (zeek-forward +
  suricata eve.json) - documented. Old Wazuh->SO forwarding NOT presented as current.
- Wazuh master/worker/indexer/dashboard, ElastiFlow+flow-relay, OpenCanary
  (local + VM 202), Shuffle->IRIS, Velociraptor 8002, MISP IOC->CDB->Wazuh,
  Greenbone lab+client scan, Proxmox lab VMs 201-205, DR posture, endpoint kit,
  Level.io model - all documented in ARCHITECTURE.md.

## No secrets

No secret values printed.
