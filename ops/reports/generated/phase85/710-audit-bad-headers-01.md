---
report_id: 710
phase: 85
title: "BAD_HEADERS — Category Enablement Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/710-audit-bad-headers-01.md
---

## Summary
BAD_HEADERS audit category verified enabled on both REST and Transport layers.

## Evidence
- **Config check**: BAD_HEADERS not in disabled_rest_categories (empty) nor disabled_transport_categories (only AUTHENTICATED, GRANTED_PRIVILEGES)
- **Category validity**: Confirmed valid category via PUT /_plugins/_security/api/audit/config test (accepted BAD_HEADERS in disabled_rest_categories)
- **Documentation**: OpenSearch Security docs list BAD_HEADERS as REST+Transport category

## Verification Method
Live config inspection; category validity test via API; documentation cross-reference.

## Finding
**VERIFIED** — BAD_HEADERS category enabled on both REST and Transport layers. Not disabled in any layer.
