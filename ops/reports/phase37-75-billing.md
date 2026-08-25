# Phase 37 — Client Billing

**Timestamp:** 2026-08-25T19:30Z
**Report ID:** P37-75
**Classification:** Internal

---

## Service Status

| Service | Status | Billable |
|---------|--------|----------|
| Detection | ACTIVE | Yes |
| Indexing | ACTIVE | Yes |
| Routing | NOT CONFIGURED | No |
| Retention | PENDING | Partial |
| Endpoints | PARTIAL (7/10) | Partial |

## Detection

- **Status:** ACTIVE
- Agent 016 producing Suricata alerts (1,095 today)
- Wazuh indexing operational
- 549 ET Open rules active

## Indexing

- **Status:** ACTIVE
- 3-node Wazuh cluster (GREEN)
- 274 shards, 100% assigned
- ISM policy attached, first deletion 2026-08-29

## Routing

- **Status:** NOT CONFIGURED
- 0 production routes
- Workflow-based routing deferred
- Not billable in current state

## Endpoints

| Metric | Value |
|--------|-------|
| Registered | 10 |
| Active | 7 |
| Disconnected | 3 (008-retired, 013, 015) |
| Coverage | 70% |

## Capacity

| Metric | Value | Status |
|--------|-------|--------|
| Disk | 84% (119G/148G) | DEGRADED |
| Memory | 75% used | OK |
| Swap | 64% | HIGH |

## Limitations

| Limitation | Impact on Billing |
|------------|-------------------|
| No routing | Routing services not billable |
| 3 agents offline | Reduced endpoint coverage |
| Field cardinality errors | May affect alert quality |
| Shuffle not integrated | No automated response |

## Billable Coverage

| Service | Billable | Notes |
|---------|----------|-------|
| Detection + Indexing | Yes | Active and functional |
| Routing | No | Not configured |
| Response/Automation | No | Shuffle not integrated |

## Summary

Client is billed for detection and indexing services only. Routing, automation, and response services are not yet billable as they are not configured. Endpoint coverage at 70% with 7 of 10 registered endpoints active.

## No secrets
