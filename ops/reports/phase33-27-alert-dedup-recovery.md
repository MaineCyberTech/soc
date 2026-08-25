# Phase 33 Alert Dedup / Recovery

Date: 2026-08-25
- State-based dedup (p33-alert-runner + p33-core-alert): transition events logged only on
  state CHANGE (UNKNOWN/HEALTHY/FAILED); recovery logged on return to HEALTHY with detail.
- No unreviewed suppression; maintenance state has expiry.

## No secrets
