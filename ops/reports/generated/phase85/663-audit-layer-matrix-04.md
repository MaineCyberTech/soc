---
report_id: 663
phase: 85
title: "Audit Layer Matrix — Ignore Users Configuration"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/663-audit-layer-matrix-04.md
---

## Summary
Audit ignore_users configuration reviewed; single entry matches Phase 85 baseline.

## Evidence
- **Current config**: `ignore_users: ["kibanaserver"]`
- **Phase 85 baseline**: `ignore_users: ["kibanaserver"]` (single entry, value redacted due to credential equivalence finding P85-AUDIT-OBS-001)
- **Live verification**: Zero audit documents exist for kibanaserver principal in security-auditlog-*

## Verification Method
Live API query; cross-referenced with audit index scan for ignore_users principal.

## Finding
**VERIFIED** — ignore_users configuration unchanged from Phase 85; correctly suppressing dashboard service polling chatter.
