# Phase 37-31: Test-Group Volume Window Design

**Date:** 2026-08-25
**Status:** DESIGN
**Owner:** 39dd09d3

## Purpose

Define the measurement window and expected metrics for the test-group routing validation phase.

## Measurements

| Metric | Description |
|---|---|
| Executions | Total Shuffle workflow executions during test window |
| Routes | Events successfully routed to test group |
| Duplicates | Events suppressed by dedup |
| Suppressions | Total events not routed (dedup + threshold + validation) |
| Malformed | Events failing validation, routed to malformed queue |
| Failures | Events affected by infrastructure failures |
| Latency (p50) | Median end-to-end latency from webhook to route |
| Latency (p95) | 95th percentile latency |
| Latency (p99) | 99th percentile latency |
| Operator workload | Notifications received, overrides required |
| Case quality | IRIS cases created (expected: 0) |

## Expected Ranges (Test Mode)

| Metric | Expected Value |
|---|---|
| Executions | < 100/day |
| Routes | < 100/day |
| Duplicates | Variable |
| Suppressions | Variable |
| Malformed | 0 (valid payloads only in test) |
| Failures | 0 (healthy infrastructure) |
| Latency (p50) | < 5s |
| Latency (p95) | < 5s |
| Latency (p99) | < 5s |
| Operator workload | 0 (until threshold reached) |
| Case quality | 0 cases |

## Window Parameters

- **Duration:** Full test cycle (start to operator sign-off)
- **Granularity:** Per-execution and daily aggregate
- **Data source:** Shuffle execution logs, datastore counters, malformed queue
- **Baseline:** Current state (2 workflows, 796 healthcheck executions, no real alert routing)

## Success Criteria

- All latency percentiles under 5s
- Zero IRIS cases created
- Counter isolation verified (synthetic vs real)
- Dedup functioning (duplicates suppressed)
- Malformed queue empty (valid test payloads)
- No operator intervention required during normal test flow

## No secrets
