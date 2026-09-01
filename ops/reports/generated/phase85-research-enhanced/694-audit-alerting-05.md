---
report_id: 694
phase: 85
title: "Audit Alerting — Security Index Attempt Alert Coverage"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/694-audit-alerting-05.md
---

## Summary
OPENSEARCH_SECURITY_INDEX_ATTEMPT alert monitor verified; detects unauthorized security index writes.

## Evidence
- **Monitor**: Security index attempt spike monitor
- **Trigger**: OPENSEARCH_SECURITY_INDEX_ATTEMPT count > 5 in 5-minute window
- **Live test**: Unauthorized write to .opendistro_security index generated event; alert triggered
- **Severity**: High — indicates potential privilege escalation attempt

## Verification Method
Monitor config inspection; synthetic unauthorized security index write; alert trigger confirmation.

## Finding
**VERIFIED** — Security index attempt alerting operational; privilege escalation attempts detected.