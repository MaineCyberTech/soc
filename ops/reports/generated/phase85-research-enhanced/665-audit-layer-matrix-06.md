---
report_id: 665
phase: 85
title: "Audit Layer Matrix — Compliance Internal Config Status"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/665-audit-layer-matrix-06.md
---

## Summary
compliance.internal_config confirmed false; COMPLIANCE_INTERNAL_CONFIG_READ/WRITE categories not capturing.

## Evidence
- **Config check**: `GET /_plugins/_security/api/audit/config` shows compliance.internal_config: false
- **Category impact**: COMPLIANCE_INTERNAL_CONFIG_READ and COMPLIANCE_INTERNAL_CONFIG_WRITE present in schema but inactive
- **Live test**: RBAC role/role-mapping changes generated 0 compliance events

## Verification Method
Direct API config query; live RBAC modification test; event stream monitoring for compliance categories.

## Finding
**NOT CAPTURING** — compliance.internal_config=false means RBAC config changes not audited via compliance categories.