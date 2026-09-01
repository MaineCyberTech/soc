---
report_id: 743
phase: 85
title: "Audit Index Settings — Critical Index Settings Coverage"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/743-audit-index-settings-04.md
---

## Summary
Critical index settings that would be audited if category enabled; highlights data integrity value.

## Evidence
- **High-value settings**:
  - `index.number_of_replicas` (data durability)
  - `index.refresh_interval` (search visibility latency)
  - `index.blocks.read_only` / `read_only_allow_delete` (emergency protection)
  - `index.lifecycle.name` / `rollover_alias` (ILM/retention control)
  - `index.routing.allocation.require.*` (data placement)
  - `index.translog.durability` (write durability)
- **Security impact**: Unauthorized changes could cause data loss, retention bypass, or availability issues

## Verification Method
Critical index setting inventory; impact analysis; audit value assessment.

## Finding
**HIGH VALUE IF ENABLED** — Index settings changes directly affect data integrity and retention; auditing critical.