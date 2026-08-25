# Phase 37 — Performance Audit

**Timestamp:** 2026-08-25T19:30Z
**Report ID:** P37-69
**Classification:** Internal

---

## CPU

| Metric | Value | Status |
|--------|-------|--------|
| PSI avg10 | 2.51 | Moderate |
| PSI avg60 | — | — |
| PSI avg300 | — | — |

CPU load is moderate with no saturation events.

## Memory

| Metric | Value | Status |
|--------|-------|--------|
| Total | 15,553 MB | — |
| Used | 11,747 MB (75%) | OK |
| Available | 3,806 MB | Adequate |
| Swap Total | 8,191 MB | — |
| Swap Used | 5,205 MB (64%) | HIGH |

## Swap Pressure

**Status: HIGH**

Swap usage at 64% indicates sustained memory pressure. Applications are paging to disk, which degrades I/O performance.

## Field Cardinality

**Status: FAIL**

- `decoder_order_size=512` insufficient for current decoder volume
- ~100 errors accumulating per minute
- Total: 18,849 "Too many fields" errors
- Restart at 19:10Z did not resolve — errors resuming

## EVE/Wazuh Event Rates

- Normal throughput
- No backpressure observed
- Analysisd PID 66961 active

## Shuffle Latency

- Workflow execution latency: <5 seconds
- No timeout events
- 796 healthcheck executions completed

## Counters

| Counter | Value |
|---------|-------|
| Workflow executions | 796 |
| Active workflows | 2 |
| Healthcheck executions | 796 |

## Queues

- Queue depth: 0%
- No backlog detected

## Disk

| Metric | Value | Status |
|--------|-------|--------|
| Usage | 84% (119G/148G) | DEGRADED |
| Watermark | LOW WATERMARK ACTIVE | Alert |
| ISM Deletion | First wave 2026-08-29 | Pending |

## /tmp

| Metric | Value | Status |
|--------|-------|--------|
| Usage | 1.6GB/7.6GB (21%) | OK |
| Cron | 03:00 UTC | Active |

## Timers

| Timer | Status |
|-------|--------|
| Backup (02:30) | Functional |
| Snapshot (03:30) | Functional |
| Healthcheck (04:30) | Functional |
| /tmp cleanup (03:00) | Functional |

## Avoidable Work

| Source | Rate | Impact |
|--------|------|--------|
| Field cardinality errors | ~100/min | CPU, log noise, decoder instability |

## Summary

| Area | Status |
|------|--------|
| CPU | OK |
| Memory | OK |
| Swap | HIGH PRESSURE |
| Disk | DEGRADED |
| /tmp | OK |
| Field Cardinality | FAIL |
| Shuffle | OK |
| Queues | OK |

## No secrets
