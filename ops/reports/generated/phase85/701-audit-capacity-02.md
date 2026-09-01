---
report_id: 701
phase: 85
title: "Audit Capacity — Watermark Configuration"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/701-audit-capacity-02.md
---

## Summary
Disk watermark configuration verified active and persistent.

## Evidence
- **Persistent settings**:
  - cluster.routing.allocation.disk.threshold_enabled: true
  - watermark.low: 85%
  - watermark.high: 90%
  - watermark.flood_stage: 95%
- **Headroom**: 43.1GB before low watermark (85% of 196.6GB = 167.1GB; current 124GB)
- **Config drift**: wazuh1.indexer.yml has threshold_enabled: false (persistent setting wins)

## Verification Method
`GET /_cluster/settings?include_defaults=false`; compared against Phase 85 snapshot capacity_guard_live.

## Finding
**VERIFIED** — Watermarks enforced at cluster level. 43.1GB headroom before low watermark triggers allocation restrictions. File config drift noted but no functional impact.
