# Phase 35: NetFlow Complement Status

Date: 2026-08-25

## ElastiFlow
- Container: elastiflow (UP, 3 days)
- Indices: elastiflow-flow-ecs-8.0-2.5-rollover-000001-clean (10.2M docs, 2.9GB)
- Metric index: elastiflow-metric-ecs-8.0-2.5-rollover-000002 (242K docs, 43MB)
- Telemetry: elastiflow-telemetry_flow-ecs-8.0-2.5-rollover-000002 (45K docs, 10.5MB)

## Complement role
- ElastiFlow provides network flow data complementary to Suricata alerts
- Flows capture metadata (src/dst IPs, ports, bytes, duration)
- Suricata captures content-level alerts
- Together they provide full network visibility

## Status: OPERATIONAL
## No secrets
