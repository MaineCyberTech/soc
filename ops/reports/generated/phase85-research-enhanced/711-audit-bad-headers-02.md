---
report_id: 711
phase: 85
title: "Audit Bad Headers — Spoofed Internal Header Detection"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/711-audit-bad-headers-02.md
---

## Summary
Spoofed internal service headers (X-Internal-Service, X-Internal-Auth) detected and logged as BAD_HEADERS.

## Evidence
- **Test**: `curl -H "X-Internal-Service: true" -H "X-Internal-Auth: secret" https://indexer:9200/`
- **Result**: BAD_HEADERS event generated with headers listed in event detail
- **Event fields**: category: BAD_HEADERS, headers: {"X-Internal-Service": "true", "X-Internal-Auth": "secret"}
- **Alerting**: BAD_HEADERS spike monitor would trigger on sustained attempts

## Verification Method
Synthetic spoofed header injection; audit event inspection; category field validation.

## Finding
**VERIFIED** — Internal header spoofing detected; BAD_HEADERS events capture attempt details.