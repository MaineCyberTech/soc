# Phase 26 PowerShell 4104 Volume and Privacy Validation

Date: 2026-08-23
Status: **METHOD READY - PILOT PENDING** (C5).

## Measurement plan (post-pilot)

| Metric | Target |
|---|---|
| 4104 volume (24h, pilot 012) | moderate (< 5K/day) |
| Sensitive-data exposure | review samples; restrict access to SOC |
| Rule false positives | review matched alerts |
| Access safeguards | log read restricted; retention 14d |

## Rollout decision

- Extend to 013/014 only after: pilot volume acceptable + policy confirmation (C1) +
  approval. Broad enable requires explicit approval.

## No secrets