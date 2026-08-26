# Phase 17 NetFlow Retention and Resource Review

Date: 2026-08-16

## Status: REVIEW COMPLETE - ILM backlog

## Data

- elastiflow-flow index: 1.4GB / 4.9M docs (single rollover generation).
- 24h flow rate: ~4.9M docs over ~7 days = ~700k/day.
- No ILM policy observed (single rollover index).

## Recommendations

1. Add ILM: hot 3d, warm 14d, delete 30d (or match Wazuh archive retention).
2. If 700k/day is too heavy: filter low-value flows at collector (SSDP/
   multicast/broadcast) - measurement-first.
3. Flow storage budget: ~2-3GB/month at current rate - acceptable.

## No secrets
