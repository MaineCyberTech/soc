---
report_id: 739
phase: 85
title: "Audit Cluster Settings — Category Summary & Recommendation"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: PARTIAL
source_path: ops/reports/generated/phase85-research-enhanced/739-audit-cluster-settings-10.md
---

## Summary
CLUSTER_SETTINGS_CHANGED disabled by default; creates audit/alerting/compliance gap; enablement low-risk, high-value.

## Evidence
- **Status**: DISABLED (OpenSearch default on transport layer)
- **Gap**: No events, no alerts, no compliance evidence for cluster config changes
- **Critical settings**: Disk watermarks, allocation, blocks, remote clusters un-audited
- **Enablement**: Remove from disabled_transport_categories + rolling restart
- **Risk**: Low (rare events, negligible overhead)
- **Compliance**: SOC2/PCI-DSS/HIPAA gap without enablement

## Verification Method
Full category assessment across status, gap, criticality, enablement, risk, compliance.

## Finding
**RECOMMEND ENABLEMENT** — Category should be enabled for compliance and security posture; low operational cost.