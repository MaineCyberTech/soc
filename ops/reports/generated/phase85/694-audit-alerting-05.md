---
report_id: 694
phase: 85
title: "Audit Alerting — Threshold Appropriateness Assessment"
date: 2026-09-01
timestamp: "2026-09-01T04:45:00Z"
classification: INTERNAL
status: COMPLETE
source_path: ops/reports/generated/phase85/694-audit-alerting-05.md
---

## Summary
Threshold appropriateness assessed: Phase 83 threshold exceeded by known stale-credential signal.

## Evidence
- **Phase 83 threshold**: >200 FAILED_LOGIN per 5-minute window
- **Observed rate**: ~7,680 FAILED_LOGIN/hour (136,026/17.71h) = ~128/min = ~640/5min
- **Dry-run result**: 529 hits in 1-min window (extrapolated >2000/5min)
- **Root cause**: Stale admin credential in wazuh-modulesd on 2 manager containers
- **Signal composition**: ~99% stale credential, ~1% genuine failed logins

## Verification Method
FAILED_LOGIN doc count / time window; dry-run execution; principal attribution analysis (phase85-audit-snapshot.json old_credential_events_live).

## Finding
**THRESHOLD EXCEEDED BY DESIGN** — Monitor correctly detecting spike. Threshold appropriate for genuine anomaly detection but currently saturated by known benign signal (revoked credential). Recommendation: remediate stale credential or adjust threshold/baseline.
