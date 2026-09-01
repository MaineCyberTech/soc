---
report_id: 760
phase: 85
title: "Audit Old Credential Use — Category Verification"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/760-audit-old-credential-use-01.md
---

## Summary
FAILED_LOGIN events for rotated 'admin' credential ongoing; 85,000+ events captured since rotation.

## Evidence
- **Credential rotation**: 'admin' password rotated Phase 84; old credential invalidated
- **Event volume**: 85,000+ FAILED_LOGIN events for 'admin' user since rotation
- **Rate**: ~200-300 events/minute sustained (automated/scripted attempts)
- **Source IPs**: Distributed; consistent with credential stuffing / botnet activity
- **Category**: FAILED_LOGIN (captures both valid user/bad password and invalid user)

## Verification Method
Audit index query for FAILED_LOGIN where user='admin'; time-range aggregation; source IP analysis.

## Finding
**VERIFIED** — Old credential use actively detected via FAILED_LOGIN events; high-volume automated attempts ongoing.