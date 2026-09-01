---
report_id: 674
phase: 85
title: "Audit Continuity — New Category Activation Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/674-audit-continuity-05.md
---

## Summary
Two new audit categories (BAD_HEADERS, OPENSEARCH_SECURITY_INDEX_ATTEMPT) verified active and capturable.

## Evidence
- **BAD_HEADERS**: 1 doc captured via live spoofed-header test (_opendistro_security_user header)
- **OPENSEARCH_SECURITY_INDEX_ATTEMPT**: 1 doc captured via unauthorized security index write test
- **CLUSTER_SETTINGS_CHANGED**: 0 docs (disabled by default on transport)
- **INDEX_SETTINGS_CHANGED**: 0 docs (disabled by default on transport)

## Verification Method
Live trigger tests executed against running cluster; pre/post category aggregation comparison.

## Finding
**PARTIAL** — BAD_HEADERS and OPENSEARCH_SECURITY_INDEX_ATTEMPT are enabled and capturable (verified live). CLUSTER_SETTINGS_CHANGED and INDEX_SETTINGS_CHANGED are disabled by default on transport layer despite not appearing in disabled_transport_categories list; require explicit enablement.
