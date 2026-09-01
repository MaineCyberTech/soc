---
report_id: 677
phase: 85
title: "Audit Continuity — Alerting Monitor Continuity"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/677-audit-continuity-08.md
---

## Summary
Both audit alerting monitors persist and operational.

## Evidence
- **phase82-audit-failed-login-spike**: enabled, 5-min schedule, threshold >0 FAILED_LOGIN
- **phase83-failed-login-spike**: enabled, 1-min schedule, threshold >200 FAILED_LOGIN
- **Live firing**: phase83 monitor ACTIVE, last notification 2026-09-01T00:38:24Z (firing continuously since 2026-08-31T08:02:45Z)

## Verification Method
`GET /_plugins/_alerting/monitors/_search`; `GET /_plugins/_alerting/monitors/alerts?monitorId=WGHXVqABGF64cJf5SH_Y`

## Finding
**VERIFIED** — Defence-in-depth alerting intact. Phase 83 monitor firing continuously due to stale credential signal (~99% of FAILED_LOGIN volume). Phase 82 monitor provides broader baseline coverage.
