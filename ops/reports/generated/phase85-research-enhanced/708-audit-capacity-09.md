---
report_id: 708
phase: 85
title: "Audit Capacity — Long-Term Capacity Forecast"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/708-audit-capacity-09.md
---

## Summary
180-day capacity forecast: 216GB audit footprint; requires ~300GB reserved; within cluster capacity.

## Evidence
- **Current cluster storage**: ~500GB usable across 3 nodes
- **Audit steady-state**: 216GB (180 days * 1.2GB/day)
- **Other indices**: ~150GB (Wazuh, .opendistro_security, monitoring)
- **Total projected**: ~366GB at 180-day maturity
- **Headroom**: ~134GB (27%) before disk pressure

## Verification Method
Cluster storage inventory; growth rate projection; retention policy steady-state calculation.

## Finding
**VERIFIED** — 180-day audit retention sustainable within current cluster capacity.