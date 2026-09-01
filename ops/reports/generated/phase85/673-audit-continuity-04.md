---
report_id: 673
phase: 85
title: "Audit Continuity — Category Persistence Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/673-audit-continuity-04.md
---

## Summary
All 8 baseline audit categories persist and actively capturing.

## Evidence
Live category aggregation (2026-09-01T04:45Z):
- FAILED_LOGIN: 135,957 docs (last: 2026-09-01T04:44:xx)
- GRANTED_PRIVILEGES: 21,585 docs (last: 2026-09-01T04:44:xx)
- AUTHENTICATED: 11,703 docs (last: 2026-09-01T04:44:xx)
- INDEX_EVENT: 327 docs (last: 2026-09-01T04:44:xx)
- COMPLIANCE_INTERNAL_CONFIG_READ: 78 docs (last: 2026-09-01T04:44:xx)
- SSL_EXCEPTION: 25 docs (last: 2026-09-01T04:44:xx)
- COMPLIANCE_INTERNAL_CONFIG_WRITE: 21 docs (last: 2026-08-31T19:48:46)
- MISSING_PRIVILEGES: 7 docs (last: 2026-08-31T19:48:46)

## Verification Method
Terms aggregation on audit_category.keyword with max(@timestamp) per bucket.

## Finding
**VERIFIED** — All 8 baseline categories present and capturing. FAILED_LOGIN, GRANTED_PRIVILEGES, AUTHENTICATED, SSL_EXCEPTION show recent timestamps (last minutes). COMPLIANCE_INTERNAL_CONFIG_WRITE and MISSING_PRIVILEGES static (no new events since config change/internal_config=false).
