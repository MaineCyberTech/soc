---
report_id: 724
phase: 85
title: "SECURITY_INDEX_ATTEMPT — Negative Test Correlation"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/724-audit-security-index-attempt-05.md
---

## Summary
OPENSEARCH_SECURITY_INDEX_ATTEMPT correlates with Phase 85 negative tests N5-N14.

## Evidence
- **Phase 85 negative tests**: N5-N14 used DASHBOARD-SVC-LOWPRIV (least-privilege) to access security index
- **Results**: All HTTP 403 "no permissions for [indices:data/read/search]" etc.
- **Category correlation**: These denial events should generate OPENSEARCH_SECURITY_INDEX_ATTEMPT (transport layer)
- **Note**: DASHBOARD-SVC-LOWPRIV is in ignore_users, so its denials not audited by design

## Verification Method
Phase 85 negative test results (phase85-audit-snapshot.json negative_tests_live N5-N14); ignore_users config.

## Finding
**CORRELATED** — Negative tests confirm security index access denied to least-privilege identities. DASHBOARD-SVC-LOWPRIV denials suppressed by ignore_users (intentional). Live test with admin (not ignored) successfully generated OPENSEARCH_SECURITY_INDEX_ATTEMPT.
