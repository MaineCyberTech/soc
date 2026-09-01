---
report_id: 745
phase: 85
title: "Audit Index Settings — Replica Count Tampering Detection Gap"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/745-audit-index-settings-06.md
---

## Summary
Replica count changes (durability control) invisible; risk of silent durability reduction.

## Evidence
- **Attack vector**: Reduce `index.number_of_replicas` from 1 to 0 → single copy only
- **Impact**: Node failure = data loss; no audit trail of change
- **Current visibility**: 0 events for replica changes
- **Detection**: Only via cluster health (unassigned shards) after failure — reactive not proactive

## Verification Method
Attack scenario modeling; durability impact analysis; detection gap assessment.

## Finding
**DURABILITY GAP** — Replica count changes not audited; silent durability reduction undetectable until failure.