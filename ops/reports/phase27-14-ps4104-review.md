# Phase 27 PowerShell 4104 Privacy and Volume Review

Date: 2026-08-24
Status: **METHOD READY - PILOT PENDING** (C3).

## Review plan (post-pilot)

| Item | Measure |
|---|---|
| Volume | 4104 count/24h on 012 (target < 5K/day) |
| Sensitive-content patterns | scan counts (credential/automation keyword frequency) WITHOUT printing captured script content |
| Access controls | log read restricted to SOC; verify no exposure |
| Retention | archives 14d applies |
| Rule quality | matched-alert false-positive review |

## No secrets