---
report_id: 713
phase: 85
title: "Audit Bad Headers — Custom Header Pattern Matching"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/713-audit-bad-headers-04.md
---

## Summary
Custom internal header patterns (X-MCT-*, X-SOC-*) also trigger BAD_HEADERS when spoofed.

## Evidence
- **Pattern config**: OpenSearch Security matches headers starting with X-Internal-, X-Forwarded-, X-Real-IP, and custom patterns
- **Test**: `curl -H "X-MCT-Internal: true" -H "X-SOC-Bypass: 1" ...`
- **Result**: Both headers triggered BAD_HEADERS events
- **Extensibility**: Pattern list configurable via audit.bad_headers_regex

## Verification Method
Custom pattern header injection; BAD_HEADERS event verification; regex pattern confirmation.

## Finding
**VERIFIED** — Custom internal header patterns protected; spoofing attempts detected.