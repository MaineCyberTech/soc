---
report_id: 744
phase: 85
title: "Audit Index Settings — Retention Policy Tampering Detection Gap"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/744-audit-index-settings-05.md
---

## Summary
ILM/retention policy changes via index settings invisible; risk of silent retention bypass.

## Evidence
- **Attack vector**: Modify `index.lifecycle.name` to policy with no delete phase → infinite retention bypass
- **Or**: Change `index.lifecycle.rollover_alias` to break rollover → index grows unbounded
- **Current visibility**: 0 events for index settings changes → tampering undetectable via audit
- **Compensating**: ISM policy state monitoring; but settings change itself not audited

## Verification Method
Attack scenario modeling; current detection gap analysis; compensating control review.

## Finding
**CRITICAL GAP** — Retention policy tampering via index settings not audited; silent data retention bypass possible.