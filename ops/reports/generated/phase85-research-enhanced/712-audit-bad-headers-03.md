---
report_id: 712
phase: 85
title: "Audit Bad Headers — Forwarded Header Spoofing Detection"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/712-audit-bad-headers-03.md
---

## Summary
X-Forwarded-For and X-Forwarded-Proto spoofing attempts detected as BAD_HEADERS.

## Evidence
- **Test**: `curl -H "X-Forwarded-For: 127.0.0.1" -H "X-Forwarded-Proto: https" ...`
- **Result**: BAD_HEADERS event generated; forwarded headers flagged as suspicious
- **Rationale**: These headers should only be set by trusted proxies; client-supplied values indicate spoofing
- **Event detail**: Headers captured (redacted values) for forensic analysis

## Verification Method
Synthetic forwarded header injection; BAD_HEADERS event capture verification.

## Finding
**VERIFIED** — Forwarded header spoofing detected; proxy bypass attempts logged.