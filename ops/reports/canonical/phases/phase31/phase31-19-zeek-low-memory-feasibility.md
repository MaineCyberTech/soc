# Phase 31 Zeek Low-Memory Feasibility

Date: 2026-08-24
Status: **NOT BENCHMARKED - DEFERRED** (Suricata proven; Zeek assessed higher-memory risk).

## Assessment

- Zeek deployment guidance reports substantially higher memory for multi-worker deployments;
  a single-process minimal profile is possible but not assumed to meet the sub-2GiB ceiling.
- Research (RESEARCH-NOTES-P31): Zeek treated as a benchmark candidate, not the assumed
  solution.

## Decision

- **Zeek deferred** as a candidate: Suricata-minimal already **measured 31MB < 2GiB** with
  0 drops (16), making Zeek benchmarking lower priority. If a Zeek test is later required,
  apply the same schema (16) and reject on measurement/packet-loss failure.

## No secrets