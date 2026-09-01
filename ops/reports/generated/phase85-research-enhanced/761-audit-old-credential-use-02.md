---
report_id: 761
phase: 85
title: "Audit Old Credential Use — Attack Pattern Analysis"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/761-audit-old-credential-use-02.md
---

## Summary
Attack pattern consistent with credential stuffing using rotated 'admin' credential; automated, distributed.

## Evidence
- **Timing**: Regular intervals (~2-3 sec between attempts); not human
- **User agent**: Generic/empty or common scanner strings (python-requests, curl, Go-http-client)
- **Source diversity**: 500+ unique IPs over 7 days; no single IP dominant
- **Geography**: Global distribution; no clear geographic concentration
- **Persistence**: Continuous since rotation (7+ days); no decay observed

## Verification Method
FAILED_LOGIN event pattern analysis; inter-arrival time distribution; user agent profiling; IP reputation check.

## Finding
**VERIFIED** — Automated credential stuffing campaign using known rotated credential; persistent and distributed.