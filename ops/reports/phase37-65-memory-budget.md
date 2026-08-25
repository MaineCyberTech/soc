# Phase 37 — Memory Budget

**Date:** 2026-08-25

## System Memory

| Metric | Value |
|--------|-------|
| Total | 15,553 MB |
| Used | 11,747 MB (75%) |
| Available | 3,806 MB |
| Swap Used | 5,205 / 8,191 MB (64%) |

## Process Allocations

| Process | Allocation |
|---------|-----------|
| Wazuh master | ~86 MB |
| Shuffle backend | ~768 MB (limit) |
| Shuffle OpenSearch | ~1,536 MB (limit) |
| Analysisd | ~86 MB |

## Field Change Impact

- **Detail:** 512 → 1024 field limit would add ~1 KB per event
- **Assessment:** Minimal

## Queues

- **Usage:** 0%

## Pressure

- **Level:** Moderate
- **Swap:** 64% (5,205/8,191 MB)

## PSI (Pressure Stall Information)

- **avg10:** 2.51

## Summary

Total memory 15,553 MB with 75% used (11,747 MB). Available 3,806 MB. Swap at 64%. Key process allocations: Wazuh master ~86 MB, Shuffle backend ~768 MB limit, Shuffle OpenSearch ~1,536 MB limit, Analysisd ~86 MB. Field change impact minimal. Queues at 0%. Memory pressure moderate with swap at 64%. PSI avg10 at 2.51.

## No secrets
