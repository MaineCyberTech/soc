---
report_id: 766
phase: 85
title: "Audit Old Credential Use — Retention Policy Interaction"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85-research-enhanced/766-audit-old-credential-use-07.md
---

## Summary
180-day retention preserves attack timeline; enables longitudinal analysis of credential stuffing campaign.

## Evidence
- **Retention**: ISM policy 180 days on security-auditlog-*
- **Timeline value**: Full attack history from rotation day preserved
- **Analysis enabled**: Rate evolution, IP infrastructure changes, tactic shifts
- **Legal/forensic**: 180-day window covers typical incident response and legal hold periods
- **Storage cost**: Attack events included in 216GB steady-state projection

## Verification Method
ISM policy verification; retention timeline analysis; forensic value assessment.

## Finding
**VERIFIED** — 180-day retention preserves full attack timeline; enables longitudinal threat analysis.