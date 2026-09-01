---
report_id: 682
phase: 85
title: "Audit Sensitive Fields — Proxy-Authorization Header Exclusion"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/682-audit-sensitive-fields-03.md
---

## Summary
Proxy-Authorization header values excluded; proxy credentials protected in audit logs.

## Evidence
- **Config**: audit.exclude_sensitive_headers: true (includes Proxy-Authorization)
- **Test request**: `curl -H "Proxy-Authorization: Basic dXNlcjpwYXNz" ...`
- **Audit event**: Shows `"headers": {"Proxy-Authorization": "[REDACTED]"}` — value not logged
- **Proxy auth**: Both Basic and Bearer proxy auth schemes redacted

## Verification Method
Synthetic request with proxy authentication; audit event Proxy-Authorization header inspection.

## Finding
**VERIFIED** — Proxy-Authorization header values fully redacted; no proxy credential leakage.