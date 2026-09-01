---
report_id: 662
phase: 85
title: "Audit Layer Matrix — Dual-Layer Coverage Validation"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/662-audit-layer-matrix-03.md
---

## Summary
Both REST and Transport audit layers simultaneously active providing comprehensive coverage.

## Evidence
- **Config verification**: `audit.enable_rest: true` AND `audit.enable_transport: true` confirmed via API
- **Event stream analysis**: security-auditlog-* shows interleaved REST and transport events
- **Category matrix**: Combined category coverage spans FAILED_LOGIN, AUTHENTICATED, GRANTED_PRIVILEGES, SSL_EXCEPTION, BAD_HEADERS, OPENSEARCH_SECURITY_INDEX_ATTEMPT, FAILED_LOGIN (old credential)

## Verification Method
Dual-layer API verification; live event stream sampling over 5-minute window; category presence confirmation.

## Finding
**VERIFIED** — Dual-layer audit matrix fully operational with no coverage gaps in enabled categories.