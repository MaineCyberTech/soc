---
report_id: 704
phase: 85
title: "Audit Capacity — Replica Configuration"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/704-audit-capacity-05.md
---

## Summary
Index replica configuration verified: 1 replica for audit indices.

## Evidence
- **Index template**: security-auditlog-template, settings.index.number_of_replicas: "1"
- **Live indices**: Both security-auditlog-* show pri.store.size ≈ 50% of store.size (confirming 1 replica)
- **HA implication**: Single node failure tolerable without data loss

## Verification Method
Index template inspection; _cat/indices primary vs total store size comparison.

## Finding
**VERIFIED** — 1 replica configured and active. HA posture maintained. Storage figures in reports include replica (total store.size).
