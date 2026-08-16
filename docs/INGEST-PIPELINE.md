# MCT SOC Ingest Pipeline

Date: 2026-08-16 (Phase 17 - full map)

## Sources -> Paths -> Destinations

1. **Endpoint agents** (Windows/macOS/Linux) -> Wazuh cluster (master+worker)
   -> alerts + archives indices.
2. **Remote syslog 15140** (tcp+udp) -> master -> syslog decoders -> alerts.
   - OpenCanary (local + VM 202), UniFi, other devices.
3. **ElastiFlow** -> netflow collector -> flow-relay -> elastiflow-flow-ecs
   indices (rollover).
4. **Security Onion** -> zeek-forward (systemd, tags ZEEK JSON lines) +
   suricata eve.json -> agent 008 -> Wazuh alerts.
5. **Greenbone** -> GMP reports + webhooks -> Shuffle -> IRIS cases.
6. **MISP** -> CDB lists -> Wazuh rules (IOC matching).
7. **Velociraptor** -> server (:8002) -> exports/evidence -> IRIS (manual).
8. **Shuffle** -> workflows from Wazuh webhooks -> IRIS case creation.
9. **Reporting** -> generators -> client scorecards (white-label).

## Storage

- wazuh-alerts-4.x-* (daily rolling)
- wazuh-archives-4.x-* (daily rolling)
- elastiflow-flow-ecs-* (rollover)
- Snapshots: local fs (keep 14) + S3 do-spaces (keep 30)

## Tuning principles

- docs/INGEST-TUNING-PRINCIPLES.md

## No secrets
