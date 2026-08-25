# Phase 37 — Monthly Ops Cycle

**Timestamp:** 2026-08-25T19:30Z
**Report ID:** P37-77
**Classification:** Internal

---

## Endpoints

| Metric | Value |
|--------|-------|
| Registered | 10 |
| Active | 7 |
| Disconnected | 3 (008-retired, 013, 015) |

## Packet Collection

| Metric | Value |
|--------|-------|
| Active packet agent | 016 |
| Suricata alerts today | 1,095 |
| Alert rule | 86601 |

## Workflows

| Metric | Value |
|--------|-------|
| Total workflows | 2 |
| Healthcheck executions | 796 |
| Type | Healthcheck only |

## Routing

- Production routes: 0
- Status: DEFERRED

## Alerts

- Field cardinality errors: ~100/min
- Total errors: 18,849
- Impact: Log noise, decoder pressure

## Backup

| Metric | Value |
|--------|-------|
| Schedule | Daily 02:30 UTC |
| Status | Active |

## Retention

| Metric | Value |
|--------|-------|
| ISM policy | Attached |
| Index pattern | wazuh-archives-14d |
| First deletion | 2026-08-29 |
| Status | PENDING |

## Capacity

| Metric | Value | Status |
|--------|-------|--------|
| Disk | 84% (119G/148G) | STABLE, LOW WATERMARK |
| Memory | 75% used | OK |
| Swap | 64% | HIGH |

## /tmp

| Metric | Value |
|--------|-------|
| Usage | 1.6GB/7.6GB (21%) |
| Cron | 03:00 UTC |
| Status | Active |

## Blockers

| Blocker | Impact |
|---------|--------|
| Field cardinality errors | Decoder instability, log noise |
| Shuffle integration not configured | No automated alert routing |
| 3 agents offline | Reduced coverage |

## Billing

- Detection + indexing: Active, billable
- Routing: Not configured, not billable

## Retrospective

| Phase | Status |
|-------|--------|
| P36 | Completed |
| P37 | In progress |

## No secrets
