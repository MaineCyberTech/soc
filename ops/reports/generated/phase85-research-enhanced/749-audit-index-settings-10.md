---
report_id: 749
phase: 85
title: "Audit Index Settings — Category Summary & Recommendation"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/749-audit-index-settings-10.md
---

## Summary
INDEX_SETTINGS_CHANGED disabled by default; creates critical audit/alerting/compliance gap for data config; enablement low-risk, high-value.

## Evidence
- **Status**: DISABLED (OpenSearch default on transport layer)
- **Critical gaps**: Retention policy tampering, replica reduction, read-only blocks, ILM changes all invisible
- **Enablement**: Remove from disabled_transport_categories + rolling restart (joint with cluster settings)
- **Risk**: Low (moderate volume, control-plane only)
- **Compliance**: SOC2/PCI-DSS/GDPR gap without enablement
- **Joint value**: Complete infrastructure (cluster + index) config audit trail

## Verification Method
Full category assessment across status, critical gaps, enablement, risk, compliance, joint value.

## Finding
**RECOMMEND ENABLEMENT** — Category should be enabled for data integrity, compliance, and security posture; low operational cost.