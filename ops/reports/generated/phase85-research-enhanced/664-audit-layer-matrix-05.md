---
report_id: 664
phase: 85
title: "Audit Layer Matrix — Disabled Transport Categories Confirmation"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/664-audit-layer-matrix-05.md
---

## Summary
CLUSTER_SETTINGS_CHANGED and INDEX_SETTINGS_CHANGED confirmed disabled by default on transport layer.

## Evidence
- **Config check**: Not present in disabled_transport_categories override list
- **Documentation**: OpenSearch Security docs confirm these are disabled by default on transport
- **Live test**: Cluster setting change (disk.watermark.low) generated 0 events; index setting change generated 0 events

## Verification Method
Live config inspection; documentation cross-reference; live trigger tests for both cluster and index settings changes.

## Finding
**CONFIRMED DISABLED** — Both categories remain at OpenSearch default (disabled on transport). Requires explicit enablement to capture.