---
report_id: 700
phase: 85
title: "Audit Capacity — Node Disk Utilization"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/700-audit-capacity-01.md
---

## Summary
Node disk utilization measured: 63.08% used, significant headroom.

## Evidence
- **3 indexer nodes**: wazuh1.indexer, wazuh2.indexer, wazuh3.indexer
- **Per node**: 196.6GB total, 124GB used, 72.6GB available (63.08% used)
- **Consistency**: All 3 nodes identical utilization (balanced)

## Verification Method
`GET /_cat/allocation?v`; parsed for node disk metrics.

## Finding
**VERIFIED** — Disk utilization well within limits. 72.6GB available per node.
